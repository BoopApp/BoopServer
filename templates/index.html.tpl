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
        
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="mobile-web-app-capable" content="yes">

        <meta property="og:image" content="{{ static_url('images/button_red.png') }}"/>

        <meta property="xsrf" content="{{ handler.xsrf_token }}"/>

        <meta property="api:init" content="{{ reverse_url('api+init') }}"/>
        <meta property="api:place" content="{{ reverse_url('api+place') }}"/>
        <meta property="api:report" content="{{ reverse_url('api+report') }}"/>
        
        <link rel="shortcut icon" href="{{ static_url('images/button_red.png') }}"/>
        
        <title>{{ page_title }}</title>
        
        <!-- Bootstrap/Bootswatch CSS -->
        <link href="//cdnjs.cloudflare.com/ajax/libs/bootswatch/3.2.0+1/superhero/bootstrap.min.css" rel="stylesheet"/>
        
        <!-- FontAwesome Icons -->
        <link href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet" />
        
        <style>
            <!--/*--><![CDATA[/*><!--*/           

            body {
                padding-top: 70px;
            }        

            .btn-text {
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .boop-button {
                min-height: 500px;
                background-image: url({{ static_url('images/button_red.png') }}); 
                background-repeat: no-repeat;
                background-position: top center;
                background-size: contain;
            }

            .boop-button.pressed {
                background-image: url({{ static_url('images/button_green.png') }}); 
            }

            /*]]>*/-->
        </style>
        
        <!-- [if lt IE 9] >
          <script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.2/html5shiv.min.js"></script>
          <script src="//cdnjs.cloudflare.com/ajax/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->
        
    </head>
    
    <body>
        
        <div class="modal fade" id="modal-loading">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h4 class="modal-title">Loading...</h4>
              </div>
              <div class="modal-body text-center">
                <p><i class="fa fa-spin fa-5x fa-refresh"></i></p>
              </div>
              <div class="modal-footer">
              </div>
            </div><!-- /.modal-content -->
          </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->
        
        <nav class="navbar navbar-default navbar-fixed-top" role="navigation">
            <div class="container-fluid">
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-top-navbar">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="/">Boop.Link</a>
                    <a id="back" class="navbar-brand" href="#"><i class="fa fa-backward"></i></a>
                </div>


                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse" id="bs-top-navbar">
                    <ul class="nav navbar-nav navbar-right">
                        <li>
                            <a href="#">
                                <i class="fa fa-sign-in"></i> Login
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <i class="fa fa-pencil-square-o"></i> Register
                            </a>
                        </li>
                    </ul>
                </div>
                <!-- /.navbar-collapse -->
            </div>
        </nav>
        
        <div id="boop-button-container" class="container-fluid">
            <div class="row-fluid">
                <div class="col-xs-12">
                    <h1 class="text-center">
                        <strong>Press me</strong>
                    </h1>
                    <div id="boop-button" class="boop-button" data-audio="{{ static_url('audio/boop.wav') }}">
                        <p class="text-center"><i id="boop-button-loading" class="fa fa-refresh fa-spin fa-5x" style="display: none"></i></p>
                    </div>
                </div>
            </div>
        </div>

        <div id="location-results-container" class="container-fluid" style="display: none">
            <div class="row-fluid">
                <div id="location-results-buttons-container" class="col-xs-12">
                    <script id="location-results-buttons-template" type="template/handlebars">
                        {{!#each places}}
                        <div class="row">
                            <button class="btn btn-default btn-lg btn-text col-xs-12 col-sm-6" data-factual-id="{{! this.factual_id }}"><strong><i class="fa fa-pencil-square-o"></i> {{! this.name }}</strong></button>
                            <a href="tel:{{! this.tel }}" class="btn btn-success btn-lg col-xs-4 col-sm-2"><strong><i class="fa fa-phone"></i></strong></a>
                            <a href="{{! this.website }}" class="btn btn-warning btn-lg col-xs-4 col-sm-2"><strong><i class="fa fa-cloud"></i></strong></a>
                            <a href="mailto:{{! this.email }}" class="btn btn-primary btn-lg col-xs-4 col-sm-2"><strong><i class="fa fa-at"></i></strong></a>
                        </div>
                        <br/>
                        {{!/each}}
                    </script>
                </div>
            </div>
        </div>

        <div id="place-result-container" class="container-fluid" style="display: none">
            <div class="row-fluid">
                <div id="place-result-info-container" class="col-xs-12">
                    <script id="place-result-info-template" type="template/handlebars">
                        <h1><strong>{{! place.name }}</strong></h1>
                        {{!#if place.hours_display }}
                        <h3><i class="fa fa-clock-o"></i> {{! place.hours_display }}</h3>
                        {{!/if}}
                        {{!#if place.website }}<h3><i class="fa fa-cloud"></i> {{! place.website }}</h3>{{!/if}}
                        {{!#if place.email }}<h3><i class="fa fa-at"></i> {{! place.email }}</h3>{{!/if}}

                        <h2><strong>Report:</strong></h2>

                        <div class="row">
                            <button type="button" class="btn btn-lg btn-default col-xs-12 col-sm-9" data-factual-id="{{! place.factual_id }}" data-reason-code="dirty-bathroom-stall" data-disposition-code="normal"><strong>Dirty Bathroom Stall</strong></button>
                            <button type="button" class="btn btn-lg btn-warning col-xs-12 col-sm-3" data-factual-id="{{! place.factual_id }}" data-reason-code="dirty-bathroom-stall" data-disposition-code="urgent"><strong>Urgent!</strong></button>
                        </div>

                        <br/>

                        <div class="row">
                            <button type="button" class="btn btn-lg btn-default col-xs-12 col-sm-12" data-factual-id="{{! place.factual_id }}" data-reason-code="not-open-during-store-hours" data-disposition-code="normal"><strong>Not Open During Store Hours</strong></button>
                        </div>

                        <br/>

                    </script>
                </div>
            </div>
        </div>
        
        <!-- Bootstrap JS -->
        
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.2.0/js/bootstrap.min.js"></script>
        
        <!-- FitText JS -->
        <script src="//cdnjs.cloudflare.com/ajax/libs/FitText.js/1.1/jquery.fittext.min.js"></script>

        <!-- Handlebars JS -->
        <script src="//cdnjs.cloudflare.com/ajax/libs/handlebars.js/2.0.0/handlebars.min.js"></script>
        
        <script>
            //<![CDATA[

            var xsrf_token = $("meta[property='xsrf']").attr('content');

            var api_init_url = $("meta[property='api:init']").attr('content');
            var api_place_url = $("meta[property='api:place']").attr('content');
            var api_report_url = $("meta[property='api:report']").attr('content');

            location_results_buttons_template = Handlebars.compile($('#location-results-buttons-template').html())
            place_result_info_template = Handlebars.compile($('#place-result-info-template').html())

            $.ajaxSetup({ cache: false });

            $(document).ready(function() {

                $('#back').click(function() {
                    $('#modal-loading').modal('show');
                    window.location = '/';
                });

                $('#boop-button').click(function() {

                    var snd = new Audio($('#boop-button').attr('data-audio')); // buffers automatically when created
                    snd.play();

                    $('#boop-button').addClass('pressed');

                    $('#modal-loading').modal('show');

                    navigator.geolocation.getCurrentPosition(function(position) {

                        $('#modal-loading').modal('show');

                        $.ajax(
                            {
                                type: 'POST',
                                url: api_init_url,
                                data: JSON.stringify(position),
                                dataType: 'json',
                                contentType: 'application/json; charset=utf-8',
                                headers: {
                                    'X-XSRFToken': xsrf_token,
                                },
                                position: position,
                                success: function(data) {
                                    console.log(data); 

                                    $('#location-results-buttons-container').empty()

                                    $('#location-results-buttons-container').append(
                                        location_results_buttons_template({places: data.places})
                                    );

                                    $('#location-results-buttons-container button').click(function() {
                
                                        $('#modal-loading').modal('show');

                                        $.ajax(
                                            {
                                                type: 'POST',
                                                url: api_place_url,
                                                data: JSON.stringify({
                                                    factual_id: $(this).attr('data-factual-id')
                                                }),
                                                dataType: 'json',
                                                contentType: 'application/json; charset=utf-8',
                                                headers: {
                                                    'X-XSRFToken': xsrf_token,
                                                },
                                                button: this,
                                                success: function(data) {
                                                    console.log(data); 

                                                    $('#place-result-info-container').empty()

                                                    $('#place-result-info-container').append(
                                                        place_result_info_template({place: data.place})
                                                    );


                                                    $('#place-result-info-container button').click(function() {
                                
                                                        $('#modal-loading').modal('show');

                                                        $.ajax(
                                                            {
                                                                type: 'POST',
                                                                url: api_report_url,
                                                                data: JSON.stringify({
                                                                    factual_id: $(this).attr('data-factual-id'),
                                                                    reason_code: $(this).attr('data-reason-code'),
                                                                    disposition_code: $(this).attr('data-disposition-code')
                                                                }),
                                                                dataType: 'json',
                                                                contentType: 'application/json; charset=utf-8',
                                                                headers: {
                                                                    'X-XSRFToken': xsrf_token,
                                                                },
                                                                button: this,
                                                                success: function(data) {
                                                                    console.log(data); 
                                                                    window.location = '/';
                                                                },
                                                            }
                                                        );
                  
                                                    });
                

                                                    $('#location-results-container').fadeOut(function(){
                                                        $('#modal-loading').modal('hide');
                                                        $('#place-result-container').fadeIn();

                                                        //$('.fittext').fitText(1.6); // Evil
                                                    });
                
                                                },
                                            }
                                        );
  
                                    });

                                    $('#boop-button-container').fadeOut(function(){
                                        $('#modal-loading').modal('hide');
                                        $('#location-results-container').fadeIn();
                                    });
                                },
                            }
                        );

                    });
                })

            });

            //]]>

        </script>
        
    </body>
    
</html>

