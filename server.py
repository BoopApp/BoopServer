#!/usr/bin/env python3.4
# -*- coding: UTF-8 -*-

import os
import sys

import pprint

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

import motor
import bson
import pymongo

import factual
import factual.utils

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

define('mongodb_uri', default='mongodb://localhost:27017/booplink', type=str, group='MongoDB')

define('mandrill_api_key', type=str, group='Mandrill')  

define('oneall_api_uri', type=str, group='OneAll Social Auth')
define('oneall_public_key', type=str, group='OneAll Social Auth')
define('oneall_private_key', type=str, group='OneAll Social Auth')

define('factual_api_key', type=str, group='Factual')
define('factual_api_secret', type=str, group='Factual')

define('page_title_prefix', default='Boop.Link', type=str, group='Page Information')
define('page_copyright', default='2014 Boop.Link Team', type=str, group='Page Information')

## ┏┓ ┏━┓┏━┓┏━╸╻ ╻┏━┓┏┓╻╺┳┓╻  ┏━╸┏━┓
## ┣┻┓┣━┫┗━┓┣╸ ┣━┫┣━┫┃┗┫ ┃┃┃  ┣╸ ┣┳┛
## ┗━┛╹ ╹┗━┛┗━╸╹ ╹╹ ╹╹ ╹╺┻┛┗━╸┗━╸╹┗╸

class BaseHandler(tornado.web.RequestHandler):
    def initialize(self, *args, **kwargs):
        super(BaseHandler, self).initialize(*args, **kwargs)

        self.motor_client = self.settings['motor_client']
        self.motor_db = self.motor_client.get_default_database()

        # Move this off to a more global situation
        self.factual = factual.Factual(self.settings['factual_api_key'], self.settings['factual_api_secret'])

        self.args = args
        self.kwargs = kwargs

        self.oid = bson.ObjectId()
        self.start = datetime.datetime.now(pytz.UTC)

    @tornado.gen.coroutine
    def prepare(self):

        self.set_header('X-Boop-Oid', str(self.oid))

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

    def get_template_namespace(self):
        namespace = super(BaseHandler, self).get_template_namespace()
        namespace.update({
            'page_copyright': self.settings.get('page_copyright'),
            'page_title_prefix': self.settings.get('page_title_prefix'),
            'page_title': '',
        })

        return namespace

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
        self.render('index.html.tpl')

class MainTestHandler(BaseHandler):
    def get(self, *args, **kwargs):
        self.render('backbonetest.html.tpl')

## ┏━┓┏━┓╻╻┏┓╻╻╺┳╸╻ ╻┏━┓┏┓╻╺┳┓╻  ┏━╸┏━┓
## ┣━┫┣━┛┃┃┃┗┫┃ ┃ ┣━┫┣━┫┃┗┫ ┃┃┃  ┣╸ ┣┳┛
## ╹ ╹╹  ╹╹╹ ╹╹ ╹ ╹ ╹╹ ╹╹ ╹╺┻┛┗━╸┗━╸╹┗╸

class APIInitHandler(BaseHandler):
    def post(self, *args, **kwargs):

        position = tornado.escape.json_decode(self.request.body);

        #places = self.factual.table('places').search('').filters({'email': {'$blank': False}, 'website': {'$blank': False}, 'tel': {'$blank': False}}).geo(
        #    factual.utils.circle(position['coords']['latitude'], position['coords']['longitude'], 2000)).sort('$distance:asc').include_count(True).data()
        places = self.factual.table('restaurants-us').search('').filters({'email': {'$blank': False}, 'website': {'$blank': False}, 'tel': {'$blank': False}}).geo(
            factual.utils.circle(position['coords']['latitude'], position['coords']['longitude'], 2000)).sort('$distance:asc').include_count(True).data()

        self.write({
            'status': 200,
            'places': places
        })

class APIPlacesHandler(BaseHandler):
    def get(self, *args, **kwargs):

        latitude = self.get_argument('latitude')
        longitude = self.get_argument('longitude')

        #places = self.factual.table('places').search('').filters({'email': {'$blank': False}, 'website': {'$blank': False}, 'tel': {'$blank': False}}).geo(
        #    factual.utils.circle(latitude, longitude, 2000)).sort('$distance:asc').include_count(True).data()

        places = self.factual.table('places').search('').filters({'email': {'$blank': False}, 'website': {'$blank': False}, 'tel': {'$blank': False}}).geo(
            factual.utils.circle(latitude, longitude, 60000)).sort('$distance:asc').include_count(True).offset(0).limit(50).data()

        self.write(tornado.escape.json_encode(places))

## ┏━┓┏━┓╻┏━┓╻  ┏━┓┏━╸┏━╸╻ ╻┏━┓┏┓╻╺┳┓╻  ┏━╸┏━┓
## ┣━┫┣━┛┃┣━┛┃  ┣━┫┃  ┣╸ ┣━┫┣━┫┃┗┫ ┃┃┃  ┣╸ ┣┳┛
## ╹ ╹╹  ╹╹  ┗━╸╹ ╹┗━╸┗━╸╹ ╹╹ ╹╹ ╹╺┻┛┗━╸┗━╸╹┗╸

class APIPlaceHandler(BaseHandler):
    def post(self, *args, **kwargs):

        place = tornado.escape.json_decode(self.request.body);

        data = self.factual.get_row('places', place['factual_id'])
        print(data)

        self.write({
            'status': 200,
            'place': data
        })

## ┏━┓┏━┓╻┏━┓┏━╸┏━┓┏━┓┏━┓╺┳╸╻ ╻┏━┓┏┓╻╺┳┓╻  ┏━╸┏━┓
## ┣━┫┣━┛┃┣┳┛┣╸ ┣━┛┃ ┃┣┳┛ ┃ ┣━┫┣━┫┃┗┫ ┃┃┃  ┣╸ ┣┳┛
## ╹ ╹╹  ╹╹┗╸┗━╸╹  ┗━┛╹┗╸ ╹ ╹ ╹╹ ╹╹ ╹╺┻┛┗━╸┗━╸╹┗╸

class APIReportHandler(BaseHandler):

    @tornado.gen.coroutine
    def post(self, *args, **kwargs):

        report = tornado.escape.json_decode(self.request.body);

        place = self.factual.get_row('places', report['factual_id'])

        http_client = tornado.httpclient.AsyncHTTPClient()

        response = yield http_client.fetch('https://mandrillapp.com/api/1.0/messages/send.json',
            method='POST',
            body=tornado.escape.json_encode(
                {
                    'key': self.settings['mandrill_api_key'],
                    'message': {
                        'html': self.render_string('report_email.html.tpl', report=report, place=place).decode('utf-8'),
                        'subject': 'You have been booped: ' + report['reason_code'] + ' (' + str(self.oid) + ')',
                        'from_email': 'reply@boop.link',
                        'from_name': 'You have been booped',
                        'to': [
                            {
                                'email': 'spencersr@gmail.com',
                                'type': 'to'
                            }
                        ],
                        'subaccount': 'boop.link',
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
        tornado.web.url(r'/places/.*$', MainHandler, name='places'),
        tornado.web.url(r'/place/.*$', MainHandler, name='place'),
        ## API Stubs
        tornado.web.url(r'/api/init$', APIInitHandler, name='api+init'),
        tornado.web.url(r'/api/place$', APIPlaceHandler, name='api+place'),
        tornado.web.url(r'/api/report$', APIReportHandler, name='api+report'),

        tornado.web.url(r'/api/places$', APIPlacesHandler, name='api+places'),
        tornado.web.url(r'/api/.*', StubHandler, name='api+wildcard'),

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

