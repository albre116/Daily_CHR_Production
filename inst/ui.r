rm(list=ls())
gc()


shinyUI(fluidPage(
  fluidRow(column(3,
                  sidebarPanel(width=12,
                               titlePanel(title="Inputs"),
                               conditionalPanel(condition="input.navbar1=='panel1' & input.navbar11=='raw_data'",    
                                                fileInput('file1', 'Choose CSV File',
                                                          accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
                                                tags$hr(),
                                                tags$div(title="Check this box if the raw data file has a row of column titles on the top of the file",
                                                         checkboxInput('header', 'Header', TRUE)),
                                                radioButtons('sep', 'Separator',
                                                             c(Comma=',',
                                                               Semicolon=';',
                                                               Tab='\t'),
                                                             ','),
                                                radioButtons('quote', 'Quote',
                                                             c(None='',
                                                               'Double Quote'='"',
                                                               'Single Quote'="'"),
                                                             '"'),
                                                tags$div(title="Adjust this slider to take a random sample of data from the input file"
                                                         ,sliderInput("rand_samp","Random Sample of Data (%)",0,100,100,step=1)),
                                                selectInput("lanes_choice","Number of Lanes to Construct",c(1,2,3))
                                                ),
                               conditionalPanel(condition="input.navbar1=='panel1' & input.navbar11=='data_load'",    
                                                fileInput('settings_file', 'Load Previous Settings?',
                                                          accept=c('RData')),
                                                uiOutput("load_dates"),
                                                uiOutput("load_outlier"),
                                                uiOutput("load_model")
                               ),
                               
                               
                               conditionalPanel(condition="input.navbar1=='panel1' & input.navbar11=='api_data'",    
                                                fileInput('api_file', 'Choose API Data File (otherwise hit update)',
                                                          accept=c('RData')),
                                                actionButton("refresh","Go Get Data From Internet"),
                                                textInput("API_SAVE_NAME","Save API to File Name:",value="API_SAVE_NAME"),
                                                downloadButton("API_SAVE","Download API Data and Tables")
                                                
                               ),
                             
                               
                               conditionalPanel(condition="input.navbar1=='panel1' & input.navbar11=='outlier'",
                                                uiOutput("date"),
                                                uiOutput("cost_lower"),
                                                uiOutput("cost_upper"),
                                                uiOutput("miles_lower"),
                                                uiOutput("miles_upper"),
                                                uiOutput("RPM_lower"),
                                                uiOutput("RPM_upper")
                               ),
                               conditionalPanel(condition="input.navbar1=='panel1' & input.navbar11=='lane_1_construct'",
                                                textInput("lane1_id","Name of Lane 1",value="Lane_1"),
                                                h4("Select Stop Count"),
                                                uiOutput("l1_stop_ct"),
                                                uiOutput("stop_table1")
                                                #h4("Select Lanes To Include"),
                                                #uiOutput("l1_lane_desc")
                               ),
                               conditionalPanel(condition="input.navbar1=='panel1' & input.navbar11=='outlier1'",
                                                uiOutput("date1"),
                                                uiOutput("cost_lower1"),
                                                uiOutput("cost_upper1"),
                                                uiOutput("miles_lower1"),
                                                uiOutput("miles_upper1"),
                                                uiOutput("RPM_lower1"),
                                                uiOutput("RPM_upper1"),
                                                uiOutput("L1_CLEANUP"),
                                                checkboxInput("salvage_L1","Try To Salvage Partial Data?",value=TRUE),
                                                checkboxInput("remove_selected","Remove Eliminated Observations from Plot?",value=FALSE),
                                                numericInput("threshold_L1","Select Minimum Number of Data Points To Consider in Series",value=10,min=1,step=1),
                                                numericInput("ratio_cut_L1","Select Ratio of Normal to Observed Variance for Removal",value=3,min=1)
                               ),
                               conditionalPanel(condition="input.navbar1=='panel1' & input.navbar11=='stop_count_modeling_L1'",
                                                uiOutput("tree_select_nsplit_L1"),uiOutput("tree_adjust_L1")
                               ),
                               conditionalPanel(condition="input.navbar1=='panel1' & input.navbar11=='lane_2_construct'",
                                                textInput("lane2_id","Name of Lane 2",value="Lane_2"),
                                                h4("Select Stop Count"),
                                                uiOutput("l2_stop_ct"),
                                                uiOutput("stop_table2")
                                                #h4("Select Lanes To Include"),
                                                #uiOutput("l2_lane_desc")
                                                
                               ),
                               conditionalPanel(condition="input.navbar1=='panel1' & input.navbar11=='outlier2'",
                                                uiOutput("date2"),
                                                uiOutput("cost_lower2"),
                                                uiOutput("cost_upper2"),
                                                uiOutput("miles_lower2"),
                                                uiOutput("miles_upper2"),
                                                uiOutput("RPM_lower2"),
                                                uiOutput("RPM_upper2")
                               ),
                               conditionalPanel(condition="input.navbar1=='panel1' & input.navbar11=='stop_count_modeling_L2'",
                                                uiOutput("tree_select_nsplit_L2"),uiOutput("tree_adjust_L2")
                               ),
                               conditionalPanel(condition="input.navbar1=='panel1' & input.navbar11=='lane_3_construct'",
                                                textInput("lane3_id","Name of Lane 3",value="Lane_3"),
                                                h4("Select Stop Count"),
                                                uiOutput("l3_stop_ct"),
                                                uiOutput("stop_table3")
                                                #h4("Select Lanes To Include"),
                                                #uiOutput("l3_lane_desc")
                               ),
                               conditionalPanel(condition="input.navbar1=='panel1' & input.navbar11=='outlier3'",
                                                uiOutput("date3"),
                                                uiOutput("cost_lower3"),
                                                uiOutput("cost_upper3"),
                                                uiOutput("miles_lower3"),
                                                uiOutput("miles_upper3"),
                                                uiOutput("RPM_lower3"),
                                                uiOutput("RPM_upper3")
                               ),
                               conditionalPanel(condition="input.navbar1=='panel1' & input.navbar11=='stop_count_modeling_L3'",
                                                uiOutput("tree_select_nsplit_L3"),uiOutput("tree_adjust_L3")
                               ),
                               conditionalPanel(condition="input.navbar1=='panel1' && input.navbar11=='weather'",    
                                                uiOutput("noaa_key"),fileInput('weather_file', 'Choose Weather Data File',accept=c('RData')),
                                                actionButton("kick_weather","Go: Lookup Weather For Listed Addresses From Internet"),
                                                h6("Pre-Selected Stations Have Best Data Coverage of Avaliable Stations"),textInput("WEATHER_SAVE_NAME","Save Weather to File Name:",value="WEATHER_SAVE_NAME"),
                                                downloadButton("WEATHER_SAVE","Download Weather Data and Tables"),uiOutput("station_list")
                               ),
                               conditionalPanel(condition = "input.navbar1=='panel2'", uiOutput("select_radio")),
                               conditionalPanel(condition = "input.navbar1=='panel3'|| input.navbar1=='panel4'", uiOutput("min_lead_slider")),
                               conditionalPanel(condition = "input.navbar1=='panel3'|| input.navbar1=='panel4'", uiOutput("max_lead_slider")),
                               conditionalPanel(condition = "input.navbar1=='panel3'|| input.navbar1=='panel4'", uiOutput("max_model_slider")),
                               conditionalPanel(condition = "input.navbar1=='panel3'|| input.navbar1=='panel4'", uiOutput("gamma_numeric")),
                               conditionalPanel(condition = "input.navbar1=='panel3'|| input.navbar1=='panel4'", uiOutput("backcast_ahead_slider")),
                               conditionalPanel(condition = "input.navbar1=='panel3' && (input.navbar13=='var_import' | input.navbar13=='cond_effect')", uiOutput("pick_numeric")),
                               conditionalPanel(condition = "input.navbar1=='panel3' && (input.navbar13=='var_import' | input.navbar13=='cond_effect')", uiOutput("linear")),
                               conditionalPanel(condition = "input.navbar1=='panel3' && (input.navbar13=='var_import' | input.navbar13=='cond_effect')", uiOutput("seasonality")),
                               conditionalPanel(condition = "input.navbar1=='panel3' && (input.navbar13=='var_import' | input.navbar13=='cond_effect')", uiOutput("interaction_check")),
                               conditionalPanel(condition = "input.navbar1=='panel3' && (input.navbar13=='var_import' | input.navbar13=='cond_effect')", uiOutput("interaction_split")),
                               conditionalPanel(condition = "input.navbar1=='panel3' || input.navbar1=='panel4'", uiOutput("add_stop_ct")),
                               conditionalPanel(condition = "input.navbar1=='panel3' && (input.navbar13=='var_import' | input.navbar13=='cond_effect')", uiOutput("response_radio")),
                               conditionalPanel(condition = "input.navbar1=='panel3' && (input.navbar13=='var_import' | input.navbar13=='cond_effect')", uiOutput("predictors_checkgroup")),
                               conditionalPanel(condition = "input.navbar1=='panel3' && input.navbar13=='GAM_effects'", downloadButton("effects","Download Conditional Effects (CSV)")),
                               conditionalPanel(condition = "input.navbar1=='panel4' && (input.navbar14=='preds' || input.navbar14=='vol_quote')", uiOutput("LCL_percentile")),
                               conditionalPanel(condition = "input.navbar1=='panel4' && (input.navbar14=='preds' || input.navbar14=='vol_quote')", uiOutput("UCL_percentile")),
                               conditionalPanel(condition = "input.navbar1=='panel4' && (input.navbar14=='pred_fwd' | input.navbar14=='preds')", uiOutput("carry_forward")),
                               conditionalPanel(condition = "input.navbar1=='panel4' && (input.navbar14=='pred_fwd' | input.navbar14=='preds')", actionButton("undopredclick","Undo Click-Set Point")),
                               conditionalPanel(condition = "input.navbar1=='panel4' && (input.navbar14=='pred_fwd' | input.navbar14=='preds')", uiOutput("matrix_values")),
                               conditionalPanel(condition = "input.navbar1=='panel4' && input.navbar14=='gam_pred'", downloadButton("predictions_GAM","Download GAM Predictions (CSV)")),
                               conditionalPanel(condition = "input.navbar1=='panel4' && input.navbar14=='vol_quote'", uiOutput("quote_date"),uiOutput("volume_checkgroup")),
                               conditionalPanel(condition="input.navbar1=='panel4' && input.navbar14=='report_image'",    
                                                textInput("settings_name","Save Settings to File Name:",value="settings_name")
                               ),
                               conditionalPanel(condition="input.navbar1=='panel4' && input.navbar14=='report_image'",
                                                downloadButton('downloadData','Download Model Image?')
                                                
                               ),
                               conditionalPanel(condition = "input.navbar1=='panel4' && input.navbar14=='report_image'", h4("Select Information to Include in Report"), uiOutput("report_quote_table"),uiOutput("report_rate_graph"), uiOutput("report_historic_graph")),
                               conditionalPanel(condition = "input.navbar1=='panel4' && input.navbar14=='report_image'",
                                                radioButtons('format', 'Document format', c('HTML', 'PDF', 'Word')),
                                                downloadButton('downloadReport')),
                               conditionalPanel(condition = "input.navbar1=='panel4' && input.navbar14=='bcst_pred'", uiOutput("backcast_length_slider")),
                               conditionalPanel(condition = "input.navbar1=='panel4' && input.navbar14=='vol_quote'", uiOutput("matrix_volume"))
                  )),
           column(9,navbarPage(title = "Version 2.0",id = "navbar1",
                               tabPanel("Dataset Selection", value = "panel1",
                                        navbarPage(title = "", id = "navbar11",
                                                   tabPanel("Raw Data",dataTableOutput("raw_data"),value="raw_data"),
                                                   tabPanel("Data Selector",fluidPage(fluidRow(column(6,h4("Select Stop Count"),uiOutput("stop_chooser"),
                                                                                                      h4("Select Total Load Cost"),uiOutput("cost_chooser"),
                                                                                                      h4("Select Origin zip"),uiOutput("origin_chooser"),
                                                                                                      h4("Select Destination zip"),uiOutput("destination_chooser"),
                                                                                                      h4("Select Load Region"),uiOutput("load_region"),
                                                                                                      h4("Select Delivery State"),uiOutput("delivery_state")
                                                   ),
                                                   column(6,h4("Select Date (Numeric Format)"),uiOutput("date_chooser"),
                                                          h4("Select Load Mileage"),uiOutput("mileage_chooser"),
                                                          h4("Select Lane Descriptions"),uiOutput("lane_chooser"),
                                                          h4("Select Origin State"),uiOutput("orig_state"),
                                                          h4("Select Delivery Region"),uiOutput("delivery_region"),
                                                          h4("Select Customer"),uiOutput("customer")
                                                   ))),value="data_load"),
                                                   tabPanel("Selected Data",dataTableOutput("selected_data"),value="selected_data"),
                                                   tabPanel("Outlier Removal",fluidPage(fluidRow(plotOutput("outlier_rpm_plot")),
                                                                                        fluidRow(dataTableOutput("outlier_rpm")))
                                                            ,value="outlier"),
                                                   tabPanel("Lane 1 Constructor",fluidPage(fluidRow(column(12,plotOutput("l1_raw_plot"))),
                                                                                           fluidRow(column(6,h4("Origin Parameters"),
                                                                                                           h4("Select Origin Zips"), uiOutput("l1_orig_zip"),
                                                                                                           h4("Select Origin States to Include"),uiOutput("l1_orig_state"),
                                                                                                           h4("Select Load Regions to Include"),uiOutput("l1_load_region")
                                                   ),
                                                   column(6,h4("Destination Parameters"),
                                                          h4("Select Destination Zips"), uiOutput("l1_dest_zip"),
                                                          h4("Select Delivery States to Include"),uiOutput("l1_delivery_state"),
                                                          h4("Select Delivery Regions to Include"),uiOutput("l1_delivery_region")
                                                   ))),value="lane_1_construct"),
                                                   tabPanel("Lane 1 Outlier Removal",fluidPage(fluidRow(plotOutput("outlier_rpm_plot1")),
                                                                                        fluidRow(dataTableOutput("outlier_rpm1")))
                                                            ,value="outlier1"),
                                                   tabPanel("Lane 1 Stop Count Model",h3("Tree of Optimal Stop Count Effect (smallest stop is reference level)"),plotOutput("stop_cluster_L1"),h3("Cross Validation Error Plot to Identify Optimal Number of Tree Splits"),
                                                            plotOutput("tree_splits_L1"),h3("Data Table of Cluster Results"),dataTableOutput("stop_table_L1"),value="stop_count_modeling_L1"),
                                                   tabPanel("Lane 2 Constructor",fluidPage(fluidRow(column(12,plotOutput("l2_raw_plot"))),
                                                                                           fluidRow(column(6,h4("Origin Parameters"),
                                                                                                           h4("Select Origin Zips"), uiOutput("l2_orig_zip"),
                                                                                                           h4("Select Origin States to Include"),uiOutput("l2_orig_state"),
                                                                                                           h4("Select Load Regions to Include"),uiOutput("l2_load_region")
                                                                                           ),
                                                                                           column(6,h4("Destination Parameters"),
                                                                                                  h4("Select Destination Zips"), uiOutput("l2_dest_zip"),
                                                                                                  h4("Select Delivery States to Include"),uiOutput("l2_delivery_state"),
                                                                                                  h4("Select Delivery Regions to Include"),uiOutput("l2_delivery_region")
                                                                                           ))),value="lane_2_construct"),
                                                   tabPanel("Lane 2 Outlier Removal",fluidPage(fluidRow(plotOutput("outlier_rpm_plot2")),
                                                                                               fluidRow(dataTableOutput("outlier_rpm2")))
                                                            ,value="outlier2"),
                                                   tabPanel("Lane 2 Stop Count Model",h3("Tree of Optimal Stop Count Effect (smallest stop is reference level)"),plotOutput("stop_cluster_L2"),h3("Cross Validation Error Plot to Identify Optimal Number of Tree Splits"),
                                                            plotOutput("tree_splits_L2"),h3("Data Table of Cluster Results"),dataTableOutput("stop_table_L2"),value="stop_count_modeling_L2"),
                                                   tabPanel("Lane 3 Constructor",fluidPage(fluidRow(column(12,plotOutput("l3_raw_plot"))),
                                                                                           fluidRow(column(6,h4("Origin Parameters"),
                                                                                                           h4("Select Origin Zips"), uiOutput("l3_orig_zip"),
                                                                                                           h4("Select Origin States to Include"),uiOutput("l3_orig_state"),
                                                                                                           h4("Select Load Regions to Include"),uiOutput("l3_load_region")
                                                                                           ),
                                                                                           column(6,h4("Destination Parameters"),
                                                                                                  h4("Select Destination Zips"), uiOutput("l3_dest_zip"),
                                                                                                  h4("Select Delivery States to Include"),uiOutput("l3_delivery_state"),
                                                                                                  h4("Select Delivery Regions to Include"),uiOutput("l3_delivery_region")
                                                                                           ))),value="lane_3_construct"),
                                                   tabPanel("Lane 3 Outlier Removal",fluidPage(fluidRow(plotOutput("outlier_rpm_plot3")),
                                                                                               fluidRow(dataTableOutput("outlier_rpm3")))
                                                            ,value="outlier3"),
                                                   tabPanel("Lane 3 Stop Count Model",h3("Tree of Optimal Stop Count Effect (smallest stop is reference level)"),plotOutput("stop_cluster_L3"),h3("Cross Validation Error Plot to Identify Optimal Number of Tree Splits"),
                                                            plotOutput("tree_splits_L3"),h3("Data Table of Cluster Results"),dataTableOutput("stop_table_L3"),value="stop_count_modeling_L3"),
                                                   tabPanel("All Lanes Raw Data",dataTableOutput("lanes"),value="all_lanes"),
                                                   tabPanel("ECON & FUEL API Data",uiOutput("fuel_econ_active"),tags$div(title="To see definitions and codes for available indicators
                                                                                            go to http://www.census.gov/data/developers/data-sets/economic-indicators.html",uiOutput("raw_api")),uiOutput("API_choice"),dataTableOutput("raw_indicators"),value="api_data"),
                                                   tabPanel("Weather API Data",uiOutput("weather_active"),tags$div(title="Enter Weather Locations of Interest",uiOutput("weather_addresses")),plotOutput("weather_plot"),uiOutput("w_maps"),dataTableOutput("stations_table"),value="weather"),
                                                   tabPanel("Daily Averages",dataTableOutput("weekly_averages"),value="weekly_avgs")

                                        )
                               ),
                               tabPanel("Raw/Imputed Data", value = "panel2",
                                        navbarPage(title = "", id = "navbar12",
                                                   tabPanel("Raw Data",plotOutput("Raw"), dataTableOutput("raw_indicators_2"),value = "raw"),
                                                   tabPanel("Imputed Data", plotOutput("Impute"),dataTableOutput("raw_indicators_3"),value = "impute")
                                        )
                               ),
                               tabPanel("Model Selection", value = "panel3",
                                        navbarPage(title = "", id = "navbar13",
                                                   tabPanel("Variable Importance", showOutput("Var_Import","highcharts"),value="var_import"),
                                                   tabPanel("Model Fit", showOutput("fit","highcharts"),value="fit"),
                                                   tabPanel("Table of Effects", dataTableOutput("GAM_effects"),value="GAM_effects")
                                        )
                               ),
                               tabPanel("Prediction", value = "panel4",
                                        navbarPage(title = "", id = "navbar14",
                                                   tabPanel("Predictor Values", uiOutput("pred_fwd"), value="pred_fwd"),
                                                   tabPanel("Model Predictions", showOutput("preds","highcharts"), value = "preds"),
                                                   tabPanel("Integrated Volume Quote",fluidPage(fluidRow(fluidRow(showOutput("quote_value","highcharts")),
                                                                                                         fluidRow(h3(textOutput("quote_final_title"))),
                                                                                                         fluidRow(dataTableOutput("quote_final")),
                                                                                                         h4("Graph of Historical and Predicted Values for Quote Period"),
                                                                                                         fluidRow(showOutput("hist_quote_chart","highcharts")),
                                                                                                         h4("Statistical Summary of Total Mileage for Historical Data"),
                                                                                                         fluidRow(dataTableOutput("mileage_table_current")),
                                                                                                         h4("Decision Tree Stop Count (Effect Relative to Chosen Cateogory)"),
                                                                                                         h6("To quote for other stop counts just add the listed effect to the current quote"),
                                                                                                         fluidRow(uiOutput("final_tree_message"),dataTableOutput("final_stop_table")),
                                                                                                         h4("Plot Of Decision Tree (Effect Relative to Chosen Category as in the table above)"),
                                                                                                         fluidRow(uiOutput("final_stop_table_message"),plotOutput("final_tree"))
                                                                                                         #h4("Raw Data"),
                                                                                                #fluidRow(dataTableOutput("vol_quote"))
                                                                                                )),value = "vol_quote"),
                                                   tabPanel("Table of Predictions", dataTableOutput("GAM_predictions"), value = "gam_pred"),
                                                   tabPanel("Generate Report, Save Model Image",
                                                            fluidPage(h4("Report Preview"), fluidRow(uiOutput("reptpreview"))), value = "report_image"),
                                                   tabPanel("Backcasting Predictions", showOutput("Backcast_graph","highcharts"), value = "bcst_pred")
                                        )
                               ),
                               tabPanel("Advanced Diagnostics", value = "panel5",
                                        navbarPage(title = "", id = "navbar15",
                                                   tabPanel("Conditional Effects", plotOutput("cond_effect"),value="cond_effect"),
                                                   tabPanel("Diagnostics", plotOutput("diagnostic"),value="diagnostic"),
                                                   tabPanel("ARIMA Error Stream", plotOutput("ts_error"),value="ts_error")
                                        )
                               )
           )
           ))))
