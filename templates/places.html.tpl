<!DOCTYPE html>
<!--[if lt IE 7 ]><html class="ie ie6" lang="en"> <![endif]-->
<!--[if IE 7 ]><html class="ie ie7" lang="en"> <![endif]-->
<!--[if IE 8 ]><html class="ie ie8" lang="en"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!--><html lang="en"> <!--<![endif]-->
    <head>
        
        <meta charset="utf-8"/>
        
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"/>
        
        <meta name="description" content=""/>
        <meta name="author" content="boop@boop.at"/>
        
        <!-- <meta property="og:image" content="{{ static_url('images/button_red.png') }}"/> -->
        
        <meta property="xsrf" content="{{ handler.xsrf_token }}"/>
        
        <!-- <link rel="shortcut icon" href="{{ static_url('images/button_red.png') }}"/> -->
        
        <title>{{ page_title }}</title>
        
        <!-- ┏┓ ┏━┓┏━┓┏━┓ -->
        <!-- ┣┻┓┃ ┃┃ ┃┣━┛ -->
        <!-- ┗━┛┗━┛┗━┛╹   -->
        
        <!-- Contact boop@boop.at if you're interested in being a boop monkey -->
        
        <!-- Bootstrap/Bootswatch CSS -->
        <!-- <link href="//cdnjs.cloudflare.com/ajax/libs/bootswatch/3.2.0+1/lumen/bootstrap.min.css -->
        <link href="http://bootswatch.com/paper/bootstrap.css" rel="stylesheet" type='text/css'/>
        
        <!-- FontAwesome Icons -->
        <link href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet" type='text/css'/>
        
        <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,800,700,600,300' rel='stylesheet' type='text/css'/>
        
        <link href="//cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.3/leaflet.css" rel="stylesheet" type='text/css' />
        
        <style>
            <!--/*--><![CDATA[/*><!--*/           

            .btn-text { 
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }  

            #places .row {
                padding-top: 10px;
            }

            /*]]>*/-->
        </style>
        
        <script src="{{ static_url('assets/js/modernizr.min.js') }}"></script>
        <script src="{{ static_url('assets/js/mobile-detect.min.js') }}"></script>
        <script src="{{ static_url('assets/js/mobile-detect-modernizr.js') }}"></script>
        
        <!-- [if lt IE 9] >
          <script src="{{ static_url('assets/js/html5shivc.min.js') }}"></script>
          <script src="{{ static_url('assets/js/respond.min.js') }}"></script>
        <![endif]-->
        
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.0/js/bootstrap.min.js"></script>
        
        <script src="//cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.3/leaflet.js"></script>
        
        <script src="{{ static_url('assets/js/geohash.js') }}"></script>
        
    </head>
    
    <body>        
        <div id="map" style="position: fixed; top: 64px; bottom: 64px; left: 0; right: 0; z-index: 0;"></div>
        <div id="overlay" style="position: fixed; top: 64px; bottom: 64px; left: 0; right: 0; background-repeat: no-repeat; background-position: center center: background-size: cover; background-image: url({{ static_url('images/circlebg.png') }}); z-index: 1;"></div>
        <header>
            <nav class="navbar navbar-default navbar-fixed-top" role="navigation" style="margin-bottom: 0">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="/">
                            <strong>boop</strong>
                        </a>
                    </div>
                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <ul class="nav navbar-nav">
                        </ul>
                        <ul class="nav navbar-nav navbar-right">
                            <li>
                                <a href="#" id="explore">
                                    <i class="fa fa-globe"></i> Explore
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <i class="fa fa-newspaper-o"></i> Recent
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <i class="fa fa-search"></i> Search
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </header>
        
        <main style="position: absolute; top: 64px; bottom: 64px; left: 0px; right: 0px; z-index: 2;">
            <section id="places" style="margin-bottom: 74px;">
                <div class="container">
                    <div class="row">
                        <div class="col-xs-12 col-md-6" style="padding-left: 0; padding-right: 0">
                            <div class="btn-group btn-group-justified">
                                <button type="button" class="btn btn-default dropdown-toggle" style="width: 100%" data-toggle="dropdown">
                                    <strong> Type of place </strong><span class="caret"></span>
                                </button>
                                <ul class="dropdown-menu" role="menu">
                                    {% for histogram in histograms %}
                                    <li>
                                        <a href="#">{{ histogram['name'] }}</a>
                                    </li>
                                    {% end %}
                                </ul>
                            </div>
                        </div>
                        <div class="col-xs-12 col-md-6" style="padding-left: 0; padding-right: 0">
                            <div class="btn-group btn-group-justified">
                                <button type="button" class="btn btn-default dropdown-toggle disabled" style="width: 100%" data-toggle="dropdown">
                                    <strong> Extra Categories </strong><span class="caret"></span>
                                </button>
                                <ul class="dropdown-menu" role="menu">
                                    {% for histogram in histograms %}
                                    <li>
                                        <a href="#">{{ histogram['name'] }}</a>
                                    </li>
                                    {% end %}
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                {% for place in places %}
                <div class="container">
                    <div class="row">
                        <a href="{{ reverse_url('place', place['geohash'][0], place['_id']) }}" role="button" class="btn btn-lg btn-default btn-text col-xs-12 col-md-9">
                            <strong>{{ place['display']['name'] }}</strong>
                        </a>
                        <a href="mailto:{{ place['display']['name'] }}" role="button" class="btn btn-lg btn-warning col-xs-4 col-md-1 {% if not place['display']['name'] %}disabled{% end %}">
                            <strong>
                                <span>
                                    <i class="fa fa-envelope"></i>
                                </span>
                                <span class="sr-only">{{ place['display']['name'] }}</span>
                            </strong>
                        </a>
                        <a href="tel:{{ place['display']['phone'] }}" role="button" class="btn btn-lg btn-success col-xs-4 col-md-1 {% if not place['display']['phone'] %}disabled{% end %}">
                            <strong>
                                <i class="fa fa-phone"></i>
                                <span class="sr-only">{{ place['display']['phone'] }}</span>
                            </strong>
                        </a>
                        <a href="{{ place['display']['website'] }}" role="button" class="btn btn-lg btn-primary col-xs-4 col-md-1 {% if not place['display']['website'] %}disabled{% end %}">
                            <strong>
                                <i class="fa fa-globe"></i>
                                <span class="sr-only">{{ place['display']['website'] }}</span>
                            </strong>
                        </a>
                    </div>
                </div>
                {% end %}
            </section>
        </main>
        
        <footer>
            <nav class="navbar navbar-default navbar-fixed-bottom" role="navigation" style="margin-bottom: 0">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-2">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="#" style="font-size: 90%">
                            &copy; 2014 Brute Technologies
                        </a>
                    </div>
                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-2">
                        <ul class="nav navbar-nav navbar-right">
                            <li>
                                <a href="http://boop.at/">
                                    <i class="fa fa-sign-in"></i> Sign up for Alpha Newsletter
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <i class="fa fa-sign-in"></i> Login
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <i class="fa fa-edit"></i> Register
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </footer>
        
        <script>
            //<![CDATA[

            var map;

            var latitude;
            var longitude;

            var geohash;

            $.ajaxSetup({ cache: false });

            $(function() {
                $('.hidden').hide().removeClass('hidden');
            });

            $('#explore').click(function() {
                $('main').fadeOut('slow'); $('#overlay').fadeOut('fast');
            });

            $('#booper').click(function() {
                $('#booper').addClass('disabled');
                $('#booper-loader').fadeIn();
                window.location = '/places/' + geohash;
            });

            $(document).ready(function() {

                map = L.map('map', {
                    zoomControl: false,
                    maxZoom: 18,
                    layers:  [
                        L.tileLayer(
                            'http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.jpeg',
                            {
                                attribution: 'Tiles by <a href="http://www.mapquest.com/">MapQuest</a> &mdash; Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
                                subdomains: '1234'
                            }
                        )
                    ]
                });

                map.on('locationfound', function (e) {
                    geohash = Geohash.encode(e.latlng.lat, e.latlng.lng, 8).toString();
                });

                map.locate({
                    'watch': true,
                    'setView': true,
                    'enableHighAccuracy': true,
                });

            });

            //]]>
        </script>
        
    </body>
    
</html>
