<!DOCTYPE html>
<!--[if lt IE 7 ]><html class="ie ie6" lang="en"> <![endif]-->
<!--[if IE 7 ]><html class="ie ie7" lang="en"> <![endif]-->
<!--[if IE 8 ]><html class="ie ie8" lang="en"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!--><html lang="en" manifest="./test.manifest"> <!--<![endif]-->
    <head>
        
        <meta charset="utf-8"/>
        
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"/>
        
        <meta name="mobile-web-app-capable" content="yes"/>
        <meta name="apple-mobile-web-app-capable" content="yes"/>
        
        <link rel="manifest" href="{{ static_url('app.manifest') }}"/>
        
        <meta name="description" content=""/>
        <meta name="author" content="boop@boop.at"/>
        
        <!-- <meta property="og:image" content="{{ static_url('images/button_red.png') }}"/> -->
        
        <meta property="xsrf" content="{{ handler.xsrf_token }}"/>
        
        <link rel="shortcut icon" href="{{ static_url('images/icons/location.png') }}"/>
        <link rel="shortcut icon" sizes="192x192" href="{{ static_url('images/icons/location.png') }}"/>
        <link rel="shortcut icon" sizes="128x128" href="{{ static_url('images/icons/location.png') }}"/>
        
        <title>Boop Alpha Layout</title>
        
        <!-- Bootstrap/Bootswatch CSS -->
        <link href="//cdnjs.cloudflare.com/ajax/libs/bootswatch/3.3.0/lumen/bootstrap.min.css" rel="stylesheet" type='text/css'/>
        
        <!-- FontAwesome Icons -->
        <link href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet" type='text/css'/>
        
        <link href="//cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.3/leaflet.css" rel="stylesheet" type='text/css'/>
        
        <style>
            <!--/*--><![CDATA[/*><!--*/


            html, body {
                overflow-x: hidden;
            }

            body {
                background-image: url(http://subtlepatterns.com/patterns/noisy_grid.png);
            }

            .funny {
                min-height: 10px;
            }               

            .leaflet-container {
                background: none;
            } 

            .btn {
                border-radius: 0;
            }

            .panel-heading {
                border-radius: 0;
            }

            .panel-body {
                border-radius: 0;
            }

            /*]]>*/-->
        </style>
        
        <script src="{{ static_url('assets/js/modernizr.min.js') }}"></script>
        <script src="{{ static_url('assets/js/mobile-detect.min.js') }}"></script>
        <script src="{{ static_url('assets/js/mobile-detect-modernizr.js') }}"></script>
        
        <!-- [if lt IE 9] >
          <script src="{{ static_url('assets/js/html5shiv.min.js') }}"></script>
          <script src="{{ static_url('assets/js/respond.min.js') }}"></script>
        <![endif]-->
        
    </head>
    
    <body style="hidden; margin-top: 50px; margin-bottom: 30vh;">
        
        <div class="modal fade" id="modal-reported" tabindex="-1" role="dialog" aria-labelledby="modal-reported-label" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
                        </button>
                        <h4 class="modal-title" id="modal-reported-label">Report has been made!</h4>
                    </div>
                    <div class="modal-body text-center">
                        <i class="fa fa-thumbs-up fa-5x"></i>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Undo!</button>
                        <button type="button" class="btn btn-success" data-dismiss="modal">Go Away!</button>
                    </div>
                </div>
                 
            </div>
        </div>
         
        
        
        <nav class="navbar navbar-default navbar-fixed-top" role="navigation">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="#">
                        <strong>
                            <i class="fa fa-bullseye"></i> Boop
                        </strong>
                    </a>
                </div>
                <div id="navbar" class="navbar-collapse collapse">
                    <form class="navbar-form navbar-right">
                        <input type="text" class="form-control" placeholder="Search..."/>
                    </form>
                    <ul class="nav navbar-nav navbar-right">
                        <li>
                            <a href="#">
                                <i class="fa fa-envelope"></i> Contact
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <i class="fa fa-info-circle"></i> About
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <i class="fa fa-sign-in"></i> Sign In/Up
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        
        <div class="container-fluid">
            <div class="row" style="background-image: linear-gradient(rgba(221,221,221,0) 33%, rgba(160,160,160,1)); padding-top: 1em; padding-bottom: 1em;">
                <div class="col-xs-12">
                    <img src="{{ static_url('images/icons/location.png') }}" style="width: 10em; height: 10em;" class="pull-left hidden-xs"/>
                    <div class="pull-left">
                        <h3 style="text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
                            <img src="{{ static_url('images/icons/location.png') }}" style="width: 1em; height: 1em;" class="pull-left visible-xs"/>
                            <strong>Place Title</strong>
                        </h3>
                        <div class="hidden-xs">
                            <small>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                                <i class="fa fa-star"></i>
                            </small>
                            <h6>Place Subtitle</h6>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row" style="margin-bottom: 18px;">
                <ul class="breadcrumb col-xs-12" style="margin-bottom: 0; border-radius: 0;">
                    <li>
                        <i class="fa fa-star"></i>
                        <i class="fa fa-star"></i>
                        <i class="fa fa-star"></i>
                        <i class="fa fa-star"></i>   
                        <i class="fa fa-star"></i>
                    </li>
                    <li>Place Subtitle</li>
                </ul>
            </div>
        </div>
        
        <div class="container">
            <div class="row">
                <div class="col-xs-12 col-md-6">
                    
                    <div class="panel panel-primary">
                        <div class="panel-heading text-center">
                            <h3 class="panel-title">
                                <strong>Amenities</strong>
                            </h3>
                        </div>
                        <div class="panel-body">
                            
                            <div class="row" style="margin-bottom: 10px;">
                                <div class="col-xs-12">
                                    
                                    <button id="dirty-bathroom" type="button" class="btn btn-lg btn-default col-xs-12 col-sm-11"  data-toggle="modal" data-target="#modal-reported">
                                        <strong>Floors Unsanitary</strong>
                                    </button>
                                    <button id="dirty-bathroom-urgent" type="button" class="btn btn-lg btn-warning col-xs-12 col-sm-1" data-toggle="modal" data-target="#modal-reported">
                                        <strong>
                                            <i class="fa fa-warning"></i>
                                        </strong>
                                    </button>
                                    
                                </div>
                            </div>
                            
                            
                            <div class="row">
                                <div class="col-xs-12">
                                    
                                    <button id="dirty-bathroom" type="button" class="btn btn-lg btn-default col-xs-12 col-sm-11"  data-toggle="modal" data-target="#modal-reported">
                                        <strong>Dirty Bathroom</strong>
                                    </button>
                                    <button id="dirty-bathroom-urgent" type="button" class="btn btn-lg btn-warning col-xs-12 col-sm-1" data-toggle="modal" data-target="#modal-reported">
                                        <strong>
                                            <i class="fa fa-warning"></i>
                                        </strong>
                                    </button>
                                    
                                </div>
                                
                            </div>
                        </div>
                    </div>
                    
                </div>
                <div class="col-xs-12 col-md-6">
                    
                    <div class="panel panel-warning">
                        <div class="panel-heading text-center">
                            <h3 class="panel-title">
                                <strong>Accessibility</strong>
                            </h3>
                        </div>
                        <div class="panel-body">
                            
                            <div class="row" style="margin-bottom: 10px;">
                                <div class="col-xs-12">
                                    
                                    <button id="not-open" type="button" class="btn btn-lg btn-default col-xs-12 col-sm-12"  data-toggle="modal" data-target="#modal-reported">
                                        <strong>
                                            <i class="fa fa-clock-o"></i> Not Open During Store Hours
                                        </strong>
                                    </button>
                                    
                                </div>
                            </div>
                            
                            
                            <div class="row">
                                <div class="col-xs-12">
                                    
                                    <button id="not-open" type="button" class="btn btn-lg btn-default col-xs-12 col-sm-11"  data-toggle="modal" data-target="#modal-reported">
                                        <strong>
                                            <i class="fa fa-wheelchair"></i> Not Accessible
                                        </strong>
                                    </button>
                                    <button id="dirty-bathroom-urgent" type="button" class="btn btn-lg btn-warning col-xs-12 col-sm-1" data-toggle="modal" data-target="#modal-reported">
                                        <strong>
                                            <i class="fa fa-warning"></i>
                                        </strong>
                                    </button>
                                    
                                </div>
                                
                            </div>
                        </div>
                    </div>
                    
                </div>
                <div class="col-xs-12">
                    
                    <div class="panel panel-danger">
                        <div class="panel-heading text-center">
                            <h3 class="panel-title">
                                <strong>Knock Knock</strong>
                            </h3>
                        </div>
                        <div class="panel-body">
                            
                            <div class="row" style="margin-bottom: 10px;">
                                <div class="col-xs-12">
                                    
                                    <button id="not-open" type="button" class="btn btn-lg btn-default col-xs-12 col-sm-12"  data-toggle="modal" data-target="#modal-reported">
                                        <strong>Let Me In!</strong>
                                    </button>
                                    
                                </div>
                            </div>
                            
                        </div>
                    </div>
                    
                </div>
            </div>
            
            <div class="row">
            </div>
            
        </div>
        
        <div id="body-fade" style="position: fixed; left: 0; right: 0;  top: 0; bottom: 0; background-size: 100% 33vh; background-repeat: no-repeat; background-position: left bottom; background-image: linear-gradient(rgba(0,0,0,0), rgba(0,0,0,1));  z-index: 7000; pointer-events: none;">
        </div>
        
        <div id="body-overlay" style="position: fixed; left: 0; right: 0;  top: 0; bottom: 0; background: black; opacity: 0.85; z-index: 7001; display: none;">
        </div>
        
        <div id="map-wrapper" class="text-center" style="position: fixed; left: 0; right: 0; height: 30vh; min-height: 100px; overflow: hidden; bottom: 0; z-index: 7002; background: white;">
            <div id="map-other-wrapper" style="position: absolute; top: 50%; height: 85vh; right: 0; left: 0;">
                <div id="map-loader" style="position: absolute; top: -50%; height: 85vh; right: 0; left: 0;">
                    <i class="fa fa-spin fa-circle-o-notch" style="line-height: 85vh; font-size: 10vh;"></i>
                </div>
                <div id="map-loader" style="position: absolute; top: -50%; height: 85vh; right: 0; left: 0;">
                    <button id="hide-map" type="button" class="btn btn-warning" style="position: absolute; top: 0; left: 0; right: 0; width: 100%; z-index: 9999">
                        <i class="fa fa-globe" style="opacity: 0.25"></i> Hide Map
                    </button>
                    <div id="map" style="position: absolute; top: 38px; bottom: 38px; right: 0; left: 0;">
                    </div>
                </div>
            </div>
            <div id="map-overlay" style="position: absolute; top: 0; bottom: 0; right: 0; left: 0; background: lightblue; opacity: 0.75;">
            </div>
            <button id="show-map" type="button" class="btn btn-default" style="position: absolute; top: 0; left: 0; right: 0; width: 100%;">
                <i class="fa fa-globe"></i> Show Map
            </button>
            <button id="locate-user" type="button" class="btn btn-primary" style="position: absolute; bottom: 0; left: 0; right: 0; width: 100%;">
                <i class="fa fa-bullseye" style="opacity: 0.25"></i> Update Location
            </button>
        </div>
        
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.js"></script>
        
        <script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.0/js/bootstrap.min.js"></script>
        
        <script src="//cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.3/leaflet.js"></script>
        
        <script src="{{ static_url('assets/js/geohash.js') }}"></script>
        
        <script>
            //<![CDATA[

            var map;

            var marker;

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

            $('#map-overlay').click(function() {
                $('#body-overlay').fadeIn();
                $('#map-overlay').fadeOut();
                $('#map-wrapper').animate({'height': '85vh'})

            });

            $('#body-overlay').click(function() {
                $('#body-overlay').fadeOut();
                $('#map-overlay').fadeIn();
                $('#map-wrapper').animate({'height': '30vh'})
            });

            $('#show-map').click(function() {
                $('#body-overlay').fadeIn();
                $('#map-overlay').fadeOut();
                $('#map-wrapper').animate({'height': '85vh'})

            });

            $('#hide-map').click(function() {
                $('#body-overlay').fadeOut();
                $('#map-overlay').fadeIn();
                $('#map-wrapper').animate({'height': '30vh'})
            });

            $(document).ready(function() {

                map = L.map('map', {
                    maxZoom: 18,
                    layers:  [
                        L.tileLayer(
                            'http://otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.jpeg',
                            {
                                subdomains: '1234'
                            }
                        )
                    ]
                });

                map.on('locationfound', function (e) {
                    $('#booper').removeClass('disabled');
                    geohash = Geohash.encode(e.latlng.lat, e.latlng.lng, 8).toString();
                    if(!marker) {
                        marker = L.marker([e.latlng.lat, e.latlng.lng]).addTo(map);
                    }
                });

                map.locate({
                    'setView': true,
                    'enableHighAccuracy': true,
                });

                $('#locate-user').click(function() {
                    map.locate({
                        'setView': true,
                        'enableHighAccuracy': true,
                    });
                });

            });

            //]]>
        </script>
        
    </body>
    
</html>
