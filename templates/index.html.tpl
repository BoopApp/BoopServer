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
        
        <link href="//cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.3/leaflet.css" rel="stylesheet" type='text/css'/>
        
        <style>
            <!--/*--><![CDATA[/*><!--*/           

                @-webkit-keyframes blink {
                    0% {
                        box-shadow: 0 0 10px 10px rgba(255,0,0,0.25);
                    }
                    50% {
                        box-shadow: 0 0 10px 10px rgba(255,0,0,0.0);
                    }
                    100% {
                        box-shadow: 0 0 10px 10px rgba(255,0,0,0.25);
                    }
                }
                @-moz-keyframes blink {
                    0% {
                        box-shadow: 0 0 10px 10px rgba(255,0,0,0.25);
                    }
                    50% {
                        box-shadow: 0 0 10px 10px rgba(255,0,0,0.0);
                    }
                    100% {
                        box-shadow: 0 0 10px 10px rgba(255,0,0,0.25);
                    }
                }
                .objblink {

                    -webkit-transition: all 1s ease-in-out;
                    -moz-transition: all 1s ease-in-out;
                    -o-transition: all 1s ease-in-out;
                    -ms-transition: all 1s ease-in-out;
                    transition: all 1s ease-in-out;
                    
                    -webkit-animation-direction: normal;
                    -webkit-animation-duration: 2s;
                    -webkit-animation-iteration-count: infinite;
                    -webkit-animation-name: blink;
                    -webkit-animation-timing-function: ease-in-out;
                    
                    -moz-animation-direction: normal;
                    -moz-animation-duration: 2s;
                    -moz-animation-iteration-count: infinite;
                    -moz-animation-name: blink;
                    -moz-animation-timing-function: ease-in-out;    
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
        <!-- <div id="overlay" style="position: fixed; top: 64px; bottom: 64px; left: 0; right: 0; background-repeat: no-repeat; background-position: center center: background-size: cover; background-image: url({{ static_url('images/circlebg.png') }}); z-index: 1;"></div> -->
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
                            <strong>boop<i class="fa fa-bullseye"></i></strong>
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
        
        <main style="position: absolute; top: 64px; bottom: 64px; left: 0px; right: 0px; z-index: 2;     pointer-events:none;">
            <section>
                <div class="container">
                    <div class="row text-center" style="padding-top: 50vh;">
                        <button id="booper" class="col-xs-6 col-xs-offset-3 btn btn-default btn-lg objblink disabled" style="position: relative; top: -30px;">Boop it up!</button>
                    </div>
                    <div class="row text-center">
                        <i id="booper-loader" class="fa fa-spin fa-circle-o-notch fa-5x hidden"></i>
                    </div>
                </div>
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
                    $('#booper').removeClass('disabled');
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
