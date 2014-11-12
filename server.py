#!/usr/bin/env python3.4
# -*- coding: UTF-8 -*-

import os
import sys

import pprint

import time
import pytz
import datetime

import tornado.httpserver
import tornado.httpclient
import tornado.ioloop
import tornado.web
import tornado.process
import tornado.options
import tornado.log
import tornado.escape
import tornado.httputil
import tornado.gen

import functools

import motor
import bson
import pymongo

import chromelogger

from geohash import encode as geohash_encode
from geohash import decode as geohash_decode

import oauthlib.oauth1

from tornado.options import options
from tornado.options import define

_ = lambda s: s

## ┏━┓┏━┓╺┳╸╻┏━┓┏┓╻┏━┓
## ┃ ┃┣━┛ ┃ ┃┃ ┃┃┗┫┗━┓
## ┗━┛╹   ╹ ╹┗━┛╹ ╹┗━┛

def config_callback(path):
    options.parse_config_file(path, final=False)

define('config', type=str, help='Path to config file', callback=config_callback, group='Config file')

define('debug', default=False, help='Debug', type=bool, group='Application')

define('cookie_secret', type=str, group='Cookies')
define('cookie_domain', type=str, group='Cookies')

define('listen_port', default=8000, help='Listen Port', type=int, group='HTTP Server')
define('listen_host', default='localhost', help='Listen Host', type=str, group='HTTP Server')

define('mongodb_uri', default='mongodb://localhost:27017/boopalpha', type=str, group='MongoDB')

define('mandrill_api_key', type=str, group='Mandrill')  

define('oneall_api_uri', type=str, group='OneAll Social Auth')
define('oneall_public_key', type=str, group='OneAll Social Auth')
define('oneall_private_key', type=str, group='OneAll Social Auth')

define('citygrid_publisher_id', type=str, group='CityGrid')

define('factual_api_key', type=str, group='Factual')
define('factual_api_secret', type=str, group='Factual')

define('page_title_prefix', default='Boop@', type=str, group='Page Information')
define('page_copyright', default='2014 Boop@ Team', type=str, group='Page Information')

## ┏┓ ┏━┓┏━┓┏━╸╻ ╻┏━┓┏┓╻╺┳┓╻  ┏━╸┏━┓
## ┣┻┓┣━┫┗━┓┣╸ ┣━┫┣━┫┃┗┫ ┃┃┃  ┣╸ ┣┳┛
## ┗━┛╹ ╹┗━┛┗━╸╹ ╹╹ ╹╹ ╹╺┻┛┗━╸┗━╸╹┗╸

class BaseHandler(tornado.web.RequestHandler):
    def initialize(self, *args, **kwargs):
        super(BaseHandler, self).initialize(*args, **kwargs)

        self.motor_client = self.settings['motor_client']
        self.motor_db = self.motor_client.get_default_database()

        self.citygrid_publisher_id = self.settings['citygrid_publisher_id']

        self.factual_api_key = self.settings['factual_api_key']
        self.factual_api_secret = self.settings['factual_api_secret']

        self.factual_oauth1_client = oauthlib.oauth1.Client(self.factual_api_key, client_secret=self.factual_api_secret)

        self.args = args
        self.kwargs = kwargs

        self.oid = bson.ObjectId()
        self.start = datetime.datetime.now(pytz.UTC)

    @tornado.gen.coroutine
    def prepare(self):

        if self.request.headers.get('X-Post-Action'):
            self.set_status(202)
            self.finish()

            yield self.motor_db.post_action.insert(
                {
                    '_id': self.oid,
                    'start': self.start,
                    'end': datetime.datetime.now(pytz.UTC),
                    'duration': (datetime.datetime.now(pytz.UTC) - self.start).total_seconds(),
                    'request': {
                        'protocol': self.request.protocol,
                        'uri': self.request.uri,
                        'body': self.request.body,
                        'full_url': self.request.full_url(),
                        'args': self.path_args,
                        'kwargs': self.path_kwargs,
                        'headers': dict((key,value) for key, value in self.request.headers.items() if not key.startswith('X-Response')),
                    },
                    'response': {
                        'headers': dict((key.replace('X-Response-',''), value) for key, value in self.request.headers.items() if key.startswith('X-Response')),
                    },
                    'kwargs': self.kwargs,
                },
                w = 0,
            )

        if self.request.headers.get('X-Throughput-Junkie'):
            self.set_status(200)
            self.finish()

        self.set_header('X-Boop-Oid', str(self.oid))

    def get_template_namespace(self):
        namespace = super(BaseHandler, self).get_template_namespace()
        namespace.update({
            'page_copyright': self.settings.get('page_copyright'),
            'page_title_prefix': self.settings.get('page_title_prefix'),
            'page_title': '',
        })

        return namespace

    def finish(self, chunk=None):
        header = chromelogger.get_header()

        if header is not None:
            self._headers[header[0]] = header[1]

        return super(BaseHandler, self).finish(chunk=chunk)

## ┏━┓┏━┓┏━╸┏━╸┏━╸┏━┓┏━┓┏━┓┏━┓╻ ╻┏━┓┏┓╻╺┳┓╻  ┏━╸┏━┓
## ┣━┛┣━┫┃╺┓┣╸ ┣╸ ┣┳┛┣┳┛┃ ┃┣┳┛┣━┫┣━┫┃┗┫ ┃┃┃  ┣╸ ┣┳┛
## ╹  ╹ ╹┗━┛┗━╸┗━╸╹┗╸╹┗╸┗━┛╹┗╸╹ ╹╹ ╹╹ ╹╺┻┛┗━╸┗━╸╹┗╸

class PageErrorHandler(BaseHandler):
    def get(self, *args, **kwargs):
        self.send_error(self.kwargs['error'])

    def post(self, *args, **kwargs):
        self.send_error(self.kwargs['error'])

## ┏━┓╺┳╸╻ ╻┏┓ ╻ ╻┏━┓┏┓╻╺┳┓╻  ┏━╸┏━┓
## ┗━┓ ┃ ┃ ┃┣┻┓┣━┫┣━┫┃┗┫ ┃┃┃  ┣╸ ┣┳┛
## ┗━┛ ╹ ┗━┛┗━┛╹ ╹╹ ╹╹ ╹╺┻┛┗━╸┗━╸╹┗╸

class StubHandler(BaseHandler):
    def check_xsrf_cookie(self, *args, **kwargs):
        pass

    def get(self, *args, **kwargs):
        self.write(dict(self.request.headers))
        print(self.request.remote_ip);

    def head(self, *args, **kwargs):
        self.write('')

    def post(self, *args, **kwargs):
        print(self.request.body)
        self.write(self.request.body)

    def patch(self, *args, **kwargs):
        self.write('')

    def delete(self, *args, **kwargs):
        self.write('')

    def options(self, *args, **kwargs):
        self.write('')

## ┏┳┓┏━┓╻┏┓╻╻ ╻┏━┓┏┓╻╺┳┓╻  ┏━╸┏━┓
## ┃┃┃┣━┫┃┃┗┫┣━┫┣━┫┃┗┫ ┃┃┃  ┣╸ ┣┳┛
## ╹ ╹╹ ╹╹╹ ╹╹ ╹╹ ╹╹ ╹╺┻┛┗━╸┗━╸╹┗╸

class MainHandler(BaseHandler):
    def get(self, *args, **kwargs):
        self.set_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')

        chromelogger.log(
            os.popen('toilet -f future boop boopity boop boop').read() + 
            "Welcome to the boop zone.\n"
            "The current time is {time}.\n".format(time=datetime.datetime.now(pytz.UTC).isoformat())
        )

        self.render('index.html.tpl')

class TestHandler(BaseHandler):
    def get(self, *args, **kwargs):
        self.render('test.html.tpl')
class TabsTestHandler(BaseHandler):
    def get(self, *args, **kwargs):
        self.render('tabstest.html.tpl')

class PlacesHandler(BaseHandler):
    @tornado.gen.coroutine
    def get(self, *args, **kwargs):

        geohash = kwargs['geohash']

        latitude, longitude = geohash_decode(geohash)

        http_client = tornado.httpclient.AsyncHTTPClient()

        #places = self.factual_client.table('places').search('').filters({'email': {'$blank': False}, 'website': {'$blank': False}, 'tel': {'$blank': False}}).geo(
        #    factual.utils.circle(latitude, longitude, 2000)).sort('$distance:asc').include_count(True).offset(0).limit(50).data()

        citygrid_latlon_search_url = tornado.httputil.url_concat(
            'http://api.citygridmedia.com/content/places/v2/search/latlon',
            {
                'format': 'json',
                'publisher': self.citygrid_publisher_id,                    
                'lat': latitude,
                'lon': longitude,
                'histograms': 'true',
                'rpp': '50',
                'radius': '50',
            }
        )

        print(citygrid_latlon_search_url)

        response = yield http_client.fetch(citygrid_latlon_search_url)

        response_json = tornado.escape.json_decode(response.body)['results']
        places = []

        for citygrid_data in response_json['locations']:

            citygrid_data['geohash'] = geohash_encode(citygrid_data['latitude'], citygrid_data['longitude'], precision=8)

            place = yield self.motor_db['places'].find_and_modify(
                {
                    'citygrid_public_id': citygrid_data['public_id'],
                },
                {
                    '$set': {
                        'citygrid.search': citygrid_data
                    },
                    '$setOnInsert': {
                        'display.name': citygrid_data['name'],
                        'display.website': citygrid_data['website'],
                        'display.phone': citygrid_data['phone_number'],
                        'display.address': citygrid_data['address']
                    },
                    '$addToSet': {
                        'geohash': {
                            '$each': [
                                geohash,
                                citygrid_data['geohash']
                            ]
                        },
                    }
                },
                upsert = True,
                new = True,
            )
            
            places.append(place);
            
        self.render('places.html.tpl', places=places, histograms=response_json['histograms'])

class PlaceHandler(BaseHandler):
    @tornado.gen.coroutine
    def get(self, *args, **kwargs):

        oid = kwargs['oid']
        geohash = kwargs['geohash']
        latitude, longitude = geohash_decode(geohash)
        
        place = yield self.motor_db['places'].find_one(
            {
                '_id': bson.ObjectId(oid),
            },
        )

        uri, headers, body = self.factual_oauth1_client.sign('http://api.v3.factual.com/t/places/03c26917-5d66-4de9-96bc-b13066173c65')

        http_client = tornado.httpclient.AsyncHTTPClient()

        response = yield http_client.fetch(uri, headers=headers)

        import pprint; pprint.pprint(tornado.escape.json_decode(response.body))

        if not 'detail' in place['citygrid']:

            http_client = tornado.httpclient.AsyncHTTPClient()

            citygrid_latlon_search_url = tornado.httputil.url_concat(
                'http://api.citygridmedia.com/content/places/v2/detail',
                {
                    'format': 'json',
                    'publisher': self.citygrid_publisher_id,                    
                    'client_ip': self.request.remote_ip,
                    'public_id': place['citygrid_public_id'],
                }
            )
    
            response = yield http_client.fetch(citygrid_latlon_search_url)

            response_json = tornado.escape.json_decode(response.body)

            for citygrid_data in response_json['locations']:
    
                import pprint; pprint.pprint(citygrid_data);

                citygrid_data['geohash'] = geohash_encode(citygrid_data['address']['latitude'], citygrid_data['address']['longitude'], precision=8)
    
                place = yield self.motor_db['places'].find_and_modify(
                    {
                        'citygrid_public_id': citygrid_data['public_id'],
                    },
                    {
                        '$set': {
                            'display.name': citygrid_data['name'],
                            'display.website': citygrid_data['contact_info']['display_url'],
                            'display.phone': citygrid_data['contact_info']['display_phone'],
                            'display.address': citygrid_data['address'],
                            'display.business_hours': citygrid_data['business_hours'],
                            'citygrid.detail': citygrid_data
                        },
                        '$addToSet': {
                            'geohash': {
                                '$each': [
                                    geohash,
                                    citygrid_data['geohash']
                                ]
                            },
                        }
                    },
                    upsert = True,
                    new = True,
                )                

        self.render('place.html.tpl', place=place)

## ┏━┓┏━┓╻┏━┓┏━╸┏━┓┏━┓┏━┓╺┳╸╻ ╻┏━┓┏┓╻╺┳┓╻  ┏━╸┏━┓
## ┣━┫┣━┛┃┣┳┛┣╸ ┣━┛┃ ┃┣┳┛ ┃ ┣━┫┣━┫┃┗┫ ┃┃┃  ┣╸ ┣┳┛
## ╹ ╹╹  ╹╹┗╸┗━╸╹  ┗━┛╹┗╸ ╹ ╹ ╹╹ ╹╹ ╹╺┻┛┗━╸┗━╸╹┗╸

class APIReportHandler(BaseHandler):

    @tornado.gen.coroutine
    def post(self, *args, **kwargs):

        #report = tornado.escape.json_decode(self.request.body);

        #place = self.factual.get_row('places', report['factual_id'])

        http_client = tornado.httpclient.AsyncHTTPClient()

        response = yield http_client.fetch('https://mandrillapp.com/api/1.0/messages/send.json',
            method='POST',
            body=tornado.escape.json_encode(
                {
                    'key': self.settings['mandrill_api_key'],
                    'message': {
                        'html': self.render_string('report_email.html.tpl', report=report, place=place).decode('utf-8'),
                        'subject': 'You have been booped: ' + report['reason_code'] + ' (' + str(self.oid) + ')',
                        'from_email': 'reply@boop.at',
                        'from_name': 'You have been booped',
                        'to': [
                            {
                                'email': 'spencersr@gmail.com',
                                'type': 'to'
                            }
                        ],
                        'subaccount': 'boop.at',
                    },
                    'async': False,
                }
            )
        )

        self.write({
            'status': 200
        })

## ┏━┓┏━╸┏━┓╻ ╻┏━╸┏━┓
## ┗━┓┣╸ ┣┳┛┃┏┛┣╸ ┣┳┛
## ┗━┛┗━╸╹┗╸┗┛ ┗━╸╹┗╸

def main():

    tornado.options.parse_command_line()

    ## ┏━┓┏━╸╺┳╸╺┳╸╻┏┓╻┏━╸┏━┓
    ## ┗━┓┣╸  ┃  ┃ ┃┃┗┫┃╺┓┗━┓
    ## ┗━┛┗━╸ ╹  ╹ ╹╹ ╹┗━┛┗━┛

    code_path = os.path.dirname(__file__)
    static_path = os.path.join(code_path, 'static')
    template_path = os.path.join(code_path, 'templates')
    support_path = os.path.join(code_path, 'support')

    handlers = [
        ## Static File Serving
        tornado.web.url(r'/static/(css/.*)', tornado.web.StaticFileHandler, {'path': static_path}),
        tornado.web.url(r'/static/(ico/.*)', tornado.web.StaticFileHandler, {'path': static_path}),
        tornado.web.url(r'/static/(img/.*)', tornado.web.StaticFileHandler, {'path': static_path}),
        tornado.web.url(r'/static/(js/.*)', tornado.web.StaticFileHandler, {'path': static_path}),

        ## Main
        tornado.web.url(r'/$', MainHandler, name='main'),
        tornado.web.url(r'/test$', TestHandler, name='test'),
        tornado.web.url(r'/tabstest$', TabsTestHandler, name='tabstest'),
        tornado.web.url(r'/places/(?P<geohash>[0123456789bcdefghjkmnpqrstuvwxyz]{8})$', PlacesHandler, name='places'),
        tornado.web.url(r'/place/(?P<geohash>[0123456789bcdefghjkmnpqrstuvwxyz]{8})/(?P<oid>[0123456789abcdef]{24})$', PlaceHandler, name='place'),

        ## API Stubs ## PERHAPS NO LONGER NEEDED
        #tornado.web.url(r'/api/report$', APIReportHandler, name='api+report'),

        tornado.web.url(r'/__stub__$', StubHandler, name='api+wildcard'),

        ## SMTP Inbound events
        tornado.web.url(r'/smtp/inbound$', StubHandler, name='smtp+inbound'),
        tornado.web.url(r'/smtp/event$', StubHandler, name='smtp+event'),
    ]

    motor_client = motor.MotorClient(options.mongodb_uri, tz_aware=True, read_preference=pymongo.read_preferences.ReadPreference.NEAREST)

    settings = dict(
        login_url = '/login/',
        logout_url = '/logout/',
        register_url = '/register/',
        static_path = static_path,
        template_path = template_path,
        support_path = support_path,
        xsrf_cookies = True,
        motor_client = motor_client,
        **options.as_dict()
    )

    tornado.log.gen_log.debug(pprint.pformat(settings))

    ## ┏━┓┏━┓┏━┓╻  ╻┏━╸┏━┓╺┳╸╻┏━┓┏┓╻
    ## ┣━┫┣━┛┣━┛┃  ┃┃  ┣━┫ ┃ ┃┃ ┃┃┗┫
    ## ╹ ╹╹  ╹  ┗━╸╹┗━╸╹ ╹ ╹ ╹┗━┛╹ ╹

    application = tornado.web.Application(handlers=handlers, **settings)

    http_server = tornado.httpserver.HTTPServer(application, xheaders=True)

    http_server.listen(options.listen_port, address=options.listen_host)

    loop = tornado.ioloop.IOLoop.instance()

    try:
        loop_status = loop.start()
    except KeyboardInterrupt:
        loop_status = loop.stop()

    return loop_status

## ┏┳┓┏━┓╻┏┓╻
## ┃┃┃┣━┫┃┃┗┫
## ╹ ╹╹ ╹╹╹ ╹

if __name__ == '__main__':
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        pass

