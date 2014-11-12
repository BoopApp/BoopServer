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
        <meta name="author" content=""/>
        
        <meta name="apple-mobile-web-app-capable" content="yes"/>
        <meta name="mobile-web-app-capable" content="yes"/>
        
        <meta property="og:image" content="{{ static_url('images/button_red.png') }}"/>
        
        <meta property="xsrf" content="{{ handler.xsrf_token }}"/>
        
        <meta property="api:init" content="{{ reverse_url('api+init') }}"/>
        <meta property="api:place" content="{{ reverse_url('api+place') }}"/>
        <meta property="api:places" content="{{ reverse_url('api+places') }}"/>
        <meta property="api:report" content="{{ reverse_url('api+report') }}"/>
        
        <link rel="shortcut icon" href="{{ static_url('images/button_red.png') }}"/>
        
        <title>{{ page_title }}</title>
        
        <!-- ┏┓ ┏━┓┏━┓┏━┓ ╻  ╻┏┓╻╻┏  -->
        <!-- ┣┻┓┃ ┃┃ ┃┣━┛ ┃  ┃┃┗┫┣┻┓ -->
        <!-- ┗━┛┗━┛┗━┛╹  ╹┗━╸╹╹ ╹╹ ╹ -->

        <!-- Bootstrap/Bootswatch CSS -->
        <link href="//cdnjs.cloudflare.com/ajax/libs/bootswatch/3.2.0+1/superhero/bootstrap.min.css" rel="stylesheet"/>
        
        <!-- FontAwesome Icons -->
        <link href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet" />
        
        <style>
            <!--/*--><![CDATA[/*><!--*/           

            body {
                padding-top: 60px;
                overflow-y: scroll;
            }        

            .btn-text {
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .overlay {
                z-index: 9999;
                position: fixed;
                top: 0;
                bottom: 0;
                left: 0;
                right: 0;
                background: rgba(0,0,0,0.5);
                display: flex;
                align-items: center;
                justify-content: center;
            }

            /*]]>*/-->
        </style>
        
        <!-- [if lt IE 9] >
          <script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.2/html5shiv.min.js"></script>
          <script src="//cdnjs.cloudflare.com/ajax/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->
        
    </head>
    
    <body>
        
        <div class="overlay" id="modal-loading" style="display: none">
            <div>
                <i id="modal-loading-icon" class="fa fa-spin fa-5x fa-refresh"></i>
            </div>
        </div>

        <div class="modal fade" id="modal-loading-old">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Loading...</h4>
                    </div>
                    <div class="modal-body text-center">
                        <p>
                            <i class="fa fa-spin fa-5x fa-refresh"></i>
                        </p>
                    </div>
                    <div class="modal-footer">
                    </div>
                </div>
            </div>
        </div>
        
        <div id="header-view"></div>
        <div id="content-view"></div>

        <!-- ╻ ╻┏━╸┏━┓╺┳┓┏━╸┏━┓╻ ╻╻┏━╸╻ ╻╺┳╸┏━╸┏┳┓┏━┓╻  ┏━┓╺┳╸┏━╸ -->
        <!-- ┣━┫┣╸ ┣━┫ ┃┃┣╸ ┣┳┛┃┏┛┃┣╸ ┃╻┃ ┃ ┣╸ ┃┃┃┣━┛┃  ┣━┫ ┃ ┣╸  -->
        <!-- ╹ ╹┗━╸╹ ╹╺┻┛┗━╸╹┗╸┗┛ ╹┗━╸┗┻┛ ╹ ┗━╸╹ ╹╹  ┗━╸╹ ╹ ╹ ┗━╸ -->

        <script id="header-view-template" type="text/html">
            <nav class="navbar navbar-default navbar-fixed-top" role="navigation">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-top-navbar">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="/"><i id="modal-loading-icon" class="fa fa-hand-o-up"></i> Boop.Link</a>
                    </div>
                    <div class="collapse navbar-collapse" id="bs-top-navbar">
                        <ul class="nav navbar-nav navbar-right">
                            <li>
                                <a href="/">
                                    <i class="fa fa-sign-in"></i> Login
                                </a>
                            </li>
                            <li>
                                <a href="/">
                                    <i class="fa fa-pencil-square-o"></i> Register
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </script>

        <!-- ╻ ╻┏━┓┏┳┓┏━╸╻ ╻╻┏━╸╻ ╻╺┳╸┏━╸┏┳┓┏━┓╻  ┏━┓╺┳╸┏━╸ -->
        <!-- ┣━┫┃ ┃┃┃┃┣╸ ┃┏┛┃┣╸ ┃╻┃ ┃ ┣╸ ┃┃┃┣━┛┃  ┣━┫ ┃ ┣╸  -->
        <!-- ╹ ╹┗━┛╹ ╹┗━╸┗┛ ╹┗━╸┗┻┛ ╹ ┗━╸╹ ╹╹  ┗━╸╹ ╹ ╹ ┗━╸ -->
        
        <script id="home-view-template" type="text/html">
            <div id="boop-button-container" class="container-fluid">
                <div class="row-fluid">
                    <div class="col-xs-12">
                        <img id="boop-button" src="{{ static_url('images/button_red.png') }}" class="img-responsive center-block"/>
                    </div>
                </div>
            </div>
        </script>

        <!-- ┏━┓╻  ┏━┓┏━╸┏━╸┏━┓╻ ╻╻┏━╸╻ ╻╺┳╸┏━╸┏┳┓┏━┓╻  ┏━┓╺┳╸┏━╸ -->
        <!-- ┣━┛┃  ┣━┫┃  ┣╸ ┗━┓┃┏┛┃┣╸ ┃╻┃ ┃ ┣╸ ┃┃┃┣━┛┃  ┣━┫ ┃ ┣╸  -->
        <!-- ╹  ┗━╸╹ ╹┗━╸┗━╸┗━┛┗┛ ╹┗━╸┗┻┛ ╹ ┗━╸╹ ╹╹  ┗━╸╹ ╹ ╹ ┗━╸ -->
        
        <script id="places-view-template" type="text/html">
            <div class="container-fluid">
                <div class="row-fluid">
                    <div id="places-item-list" class="col-xs-12">
                    </div>
                </div>
            </div> 
        </script>
        
        <!-- ┏━┓╻  ┏━┓┏━╸┏━╸┏━┓╻╺┳╸┏━╸┏┳┓╻ ╻╻┏━╸╻ ╻╺┳╸┏━╸┏┳┓┏━┓╻  ┏━┓╺┳╸┏━╸ -->
        <!-- ┣━┛┃  ┣━┫┃  ┣╸ ┗━┓┃ ┃ ┣╸ ┃┃┃┃┏┛┃┣╸ ┃╻┃ ┃ ┣╸ ┃┃┃┣━┛┃  ┣━┫ ┃ ┣╸  -->
        <!-- ╹  ┗━╸╹ ╹┗━╸┗━╸┗━┛╹ ╹ ┗━╸╹ ╹┗┛ ╹┗━╸┗┻┛ ╹ ┗━╸╹ ╹╹  ┗━╸╹ ╹ ╹ ┗━╸ -->

        <script id="places-item-view-template" type="text/html">
            <div class="row">
                <a href="/place/<%- factual_id %>" class="btn btn-default btn-lg btn-text col-xs-12 col-sm-6"><strong><i class="fa fa-pencil-square-o"></i> <%- name %></strong></button>
                <a href="tel:<%- tel %>" class="btn btn-success btn-lg col-xs-4 col-sm-2"><strong><i class="fa fa-phone"></i></strong></a>
                <a href="<%- website %>" class="btn btn-warning btn-lg col-xs-4 col-sm-2"><strong><i class="fa fa-cloud"></i></strong></a>
                <a href="mailto:<%- email %>" class="btn btn-primary btn-lg col-xs-4 col-sm-2"><strong><i class="fa fa-at"></i></strong></a>
            </div>
            <br/>
        </script>

        <!-- ┏━┓╻  ┏━┓┏━╸┏━╸╺┳┓┏━╸╺┳╸┏━┓╻╻  ╻ ╻╻┏━╸╻ ╻╺┳╸┏━╸┏┳┓┏━┓╻  ┏━┓╺┳╸┏━╸ -->
        <!-- ┣━┛┃  ┣━┫┃  ┣╸  ┃┃┣╸  ┃ ┣━┫┃┃  ┃┏┛┃┣╸ ┃╻┃ ┃ ┣╸ ┃┃┃┣━┛┃  ┣━┫ ┃ ┣╸  -->
        <!-- ╹  ┗━╸╹ ╹┗━╸┗━╸╺┻┛┗━╸ ╹ ╹ ╹╹┗━╸┗┛ ╹┗━╸┗┻┛ ╹ ┗━╸╹ ╹╹  ┗━╸╹ ╹ ╹ ┗━╸ -->

        <script id="place-detail-view-template" type="text/html">
            <div class="container-fluid">
                <div class="row-fluid">
                    <div class="col-xs-12">
                            <h1><strong><%- name %></strong></h1>
                            <small><% if ( typeof(hours_display) != "undefined" ){ %><%- hours_display %><% } %></small>

                            <h3><i class="fa fa-cloud"></i> <%- website %></h3>
                            <h3><i class="fa fa-at"></i> <%- email %></h3>
      
                            <h2><strong>Report:</strong></h2>
    
                            <div class="row">
                                <button id="dirty-bathroom" type="button" class="btn btn-lg btn-default col-xs-12 col-sm-9"><strong>Dirty Bathroom Stall</strong></button>
                                <button id="dirty-bathroom-urgent" type="button" class="btn btn-lg btn-warning col-xs-12 col-sm-3"><strong>Urgent!</strong></button>
                            </div>  
                                
                            <br/>  
                        
                            <div class="row">
                                <button id="not-open" type="button" class="btn btn-lg btn-default col-xs-12 col-sm-12"><strong>Not Open During Store Hours</strong></button>
                            </div>
            
                            <br/>            
                    </div>
                </div>  
            </div>              
        </script>
        
        <!-- Bootstrap JS -->
        
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.2.0/js/bootstrap.min.js"></script>
        
        <!-- Backbone JS /Underscore JS -->
        
        <script src="//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.7.0/underscore-min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/backbone.js/1.1.2/backbone-min.js"></script>
        
        <!-- Global Awesomeness -->
        
        <script>
            //<![CDATA[
            
            //]]>
        </script>
        
        <!-- Backbone Main -->
        
        <script>
            //<![CDATA[
            
            // ┏━┓╻  ┏━┓┏━╸┏━╸┏┳┓┏━┓╺┳┓┏━╸╻  
            // ┣━┛┃  ┣━┫┃  ┣╸ ┃┃┃┃ ┃ ┃┃┣╸ ┃  
            // ╹  ┗━╸╹ ╹┗━╸┗━╸╹ ╹┗━┛╺┻┛┗━╸┗━╸

            window.Place = Backbone.Model.extend({
            
                idAttribute: 'factual_id',

                urlRoot: $("meta[property='api:place']").attr('content'),
            
                initialize:function () {
                    //this.reports = new PlaceCollection();
                    //this.reports.url = '../api/places/' + this.id + '/reports';
                }
            
            });

            var place = new Place();

            // ┏━┓╻  ┏━┓┏━╸┏━╸┏━╸┏━┓╻  ╻  ┏━╸┏━╸╺┳╸╻┏━┓┏┓╻
            // ┣━┛┃  ┣━┫┃  ┣╸ ┃  ┃ ┃┃  ┃  ┣╸ ┃   ┃ ┃┃ ┃┃┗┫
            // ╹  ┗━╸╹ ╹┗━╸┗━╸┗━╸┗━┛┗━╸┗━╸┗━╸┗━╸ ╹ ╹┗━┛╹ ╹
            
            window.PlaceCollection = Backbone.Collection.extend({

                url: $("meta[property='api:places']").attr('content'),

                model: Place,

            });

            var places = new PlaceCollection();

            // ╻ ╻┏━╸┏━┓╺┳┓┏━╸┏━┓╻ ╻╻┏━╸╻ ╻
            // ┣━┫┣╸ ┣━┫ ┃┃┣╸ ┣┳┛┃┏┛┃┣╸ ┃╻┃
            // ╹ ╹┗━╸╹ ╹╺┻┛┗━╸╹┗╸┗┛ ╹┗━╸┗┻┛

            window.HeaderView = Backbone.View.extend({
            
                template: _.template($("#header-view-template").html()),

                initialize: function () {
                },
            
                render: function () {
                    $(this.el).html(this.template());
                    return this;
                },
            
                events: {
                },
            
                select: function(menuItem) {
                    $('.nav li').removeClass('active');
                    $('.' + menuItem).addClass('active');
                }
            
            });

            // ╻ ╻┏━┓┏┳┓┏━╸╻ ╻╻┏━╸╻ ╻
            // ┣━┫┃ ┃┃┃┃┣╸ ┃┏┛┃┣╸ ┃╻┃
            // ╹ ╹┗━┛╹ ╹┗━╸┗┛ ╹┗━╸┗┻┛

            window.HomeView = Backbone.View.extend({
            
                template: _.template($("#home-view-template").html()),

                initialize: function () {
                },
            
                render: function () {
                    $(this.el).html(this.template());
                    return this;
                },
            
                events: {
                    "click #boop-button": "boop"

                },
            
                boop: function () {

                    $('#modal-loading-icon').removeClass('fa-refresh');
                    $('#modal-loading-icon').removeClass('fa-globe');

                    $('#modal-loading-icon').addClass('fa-globe');

                    $('#modal-loading').fadeIn();

                    navigator.geolocation.getCurrentPosition(function(position) {
                        //window.location = "/places/" + position.coords.latitude.toString() + "/" +  position.coords.longitude.toString();
                        //window.location = "/places/" + position.coords.latitude.toString() + "/" +  position.coords.longitude.toString();
                        //app.navigate("/places/" + position.coords.latitude.toString() + "/" +  position.coords.longitude.toString(), { trigger: true });
                        delete(app.placesView); //Kill caching
                        Backbone.history.navigate("places/" + position.coords.latitude.toString() + "/" +  position.coords.longitude.toString(), { trigger: true });
                    });
                }
            
            });

            window.PlacesItemView = Backbone.View.extend({
            
                template: _.template($("#places-item-view-template").html()),

                initialize: function () {
                },
            
                render: function () {
                    $(this.el).html(this.template(this.model.toJSON()));
                    return this;
                },
            
                events: {
                },

            });

            window.PlacesView = Backbone.View.extend({
            
                template: _.template($("#places-view-template").html()),

                initialize: function (options) {

                    // Reinit
                    places = new PlaceCollection();

                    this.listenTo(places, 'reset', this.addPlaces);                    

                    $('#modal-loading-icon').removeClass('fa-refresh');
                    $('#modal-loading-icon').removeClass('fa-globe');

                    $('#modal-loading-icon').addClass('fa-refresh');

                    $('#modal-loading').fadeIn();

                    places.fetch({
                        reset: true,
                        data:{
                            latitude: options.latitude,
                            longitude: options.longitude,
                        },
                        success: function (data) {
                            $('#modal-loading').fadeOut();
                        }
                    });

                },
            
                render: function () {
                    $(this.el).html(this.template());                    
                    return this;
                },
            
                events: {
                },

                addPlace: function (place) {
                    var view = new PlacesItemView({model: place});
                    var item = this.$("#places-item-list").append(view.render().el);
                },

                addPlaces: function (places) {
                    places.each(this.addPlace, this);
                },

            });

            window.PlaceView = Backbone.View.extend({
            
                template: _.template($("#place-detail-view-template").html()),

                initialize: function (options) {
                    this.model = places.get(options.id);
                    console.log(place);
                },
            
                render: function () {
                    $(this.el).html(this.template(this.model.toJSON()));
                    return this;
                    console.log($(this.el));
                },
            
                events: {
                },

            });

            // ┏━┓┏━┓╻ ╻╺┳╸┏━╸┏━┓
            // ┣┳┛┃ ┃┃ ┃ ┃ ┣╸ ┣┳┛
            // ╹┗╸┗━┛┗━┛ ╹ ┗━╸╹┗╸

            window.Router = Backbone.Router.extend({
            
                routes: {
                    "": "home",
                    "place/:id": "place",
                    "places/:latitude/:longitude": "places",
                },
            
                initialize: function () {
                    this.headerView = new HeaderView();
                    $('#header-view').html(this.headerView.render().el);            
                },
            
                home: function () {
                    // Since the home view never changes, we instantiate it and render it only once
                    if (!this.homeView) {
                        this.homeView = new HomeView();
                        this.homeView.render();
                    } else {
                        this.homeView.delegateEvents(); // delegate events when the view is recycled
                    }
                    $("#content-view").html(this.homeView.el);
                },

                place: function (id) {
                    $("#content-view").html(new PlaceView({id: id}).render().el);
                },

                places: function (latitude, longitude) {
                    // Testing simple caching
                    if (!this.placesView) {
                        this.placesView = new PlacesView({latitude: latitude, longitude: longitude})
                        this.placesView.render();
                    } else {
                        this.placesView.delegateEvents(); // delegate events when the view is recycled
                    }                                        

                    $("#content-view").html(this.placesView.el);
                },
            
            });

            window.app = new Router();
            Backbone.history.start({pushState: true, root: '/dev/'});

            window.document.addEventListener('click', function(e) {
                e = e || window.event
                var target = e.target || e.srcElement
                if ( target.nodeName.toLowerCase() === 'a' ) {
                    e.preventDefault()
                    var uri = target.getAttribute('href')
                    app.navigate(uri.substr(1), true)
                }
            });

            window.addEventListener('popstate', function(e) {
                app.navigate(location.pathname.substr(1), true);
            }); 
            
            $(document).on("click", "a:not([data-bypass])[href^='/']", function(evt) {
                console.log(this);
                evt.preventDefault();
                Backbone.history.navigate($(this).attr('href'), true);
            });                       
            

            //]]>
        </script>
        
        <!-- jQuery Document Ready -->
        
        <script>
            //<![CDATA[

            $.ajaxSetup({ cache: false });

            $(document).ready(function() {


            });

            //]]>
        </script>
        
    </body>
    
</html>

