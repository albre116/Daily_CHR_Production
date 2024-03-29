rm(list=ls())
gc()
options(shiny.maxRequestSize=500*1024^2)###500 megabyte file upload limit set


#################################
shinyServer(function(input, output, session) { # server is defined within these parentheses
  
  ######## click value reactive value for predictions graph set
  predclickval <- reactiveValues(graphID = NULL, target = NULL, value = NULL, active = NULL)
  
  
  # render UI input elements for use in UI wrapper - come back to this section to calculate length dynamically
  
  #new UI elements to insert into UI for bundle 1
  
  ####UI elements for live report preview###########
  
  output$reptpreview <- renderUI({
    includeRmd("report.Rmd")
  })
  
  #Function to render .Rmd formatted markdown template as html for inclusion in a shiny app webpage
  includeRmd <- function(path){
    if (!require(knitr))
      stop("knitr package is not installed")
    if (!require(markdown))
      stop("Markdown package is not installed")
    shiny:::dependsOnFile(path)
    contents = paste(readLines(path, warn = FALSE), collapse = '\n')
    html <- knitr::knit2html(text = contents, fragment.only = TRUE)
    Encoding(html) <- 'UTF-8'
    return(HTML(html))
  }
  
  
  ####UI elements for API Choices####
  output$API_choice<-renderUI({
    if(is.null(API())){return(NULL)}
    DATA_I<-API()[["DATA_I"]]
    dest=names(DATA_I)[-1]
    cc=dest
    for (i in 1:length(dest)){
      cc[i]=colnames(DATA_I[[dest[i]]])
    }
    selectedcc <- cc
    if (!is.null(Read_Settings()[["API_choice"]])){
      selectedcc <- cc[which(cc%in%Read_Settings()[["API_choice"]])]}
    #data.frame(Abbreviations=dest,Full_Names=cc)
    checkboxGroupInput("API_choice", "Choose Economic Indicators",
                       cc,selected=selectedcc)
    
  })
  
  
  output$date_chooser<-renderUI({
    chooserInput("date", "Available", "Selected",
                 choices()[-2], choices()[2], size = 10, multiple = TRUE
    )
    
  })
  
  
  output$stop_chooser<-renderUI({
    chooserInput("stop", "Available", "Selected",
                 choices()[-24],choices()[24], size = 10, multiple = TRUE
    )
    
  })
  
  
  output$cost_chooser<-renderUI({
    chooserInput("cost", "Available", "Selected",
                 choices()[-34], choices()[34], size = 10, multiple = TRUE
    )
    
  })
  
  output$mileage_chooser<-renderUI({
    chooserInput("mileage", "Available", "Selected",
                 choices()[-29], choices()[29], size = 10, multiple = TRUE
    )
    
  })
  
  output$destination_chooser<-renderUI({
    chooserInput("destination", "Available", "Selected",
                 choices()[-7], choices()[7], size = 10, multiple = TRUE
    )
    
  })
  
  output$origin_chooser<-renderUI({
    chooserInput("origin", "Available", "Selected",
                 choices()[-6], choices()[6], size = 10, multiple = TRUE
    )
    
  })
  

  
  output$orig_state<-renderUI({
    chooserInput("orig_state", "Available", "Selected",
                 choices()[-9], choices()[9], size = 10, multiple = TRUE
    )
    
  })
  

  
  output$delivery_state<-renderUI({
    chooserInput("delivery_state", "Available", "Selected",
                 choices()[-11], choices()[11], size = 10, multiple = TRUE
    )
    
  })
  

  
  output$customer<-renderUI({
    chooserInput("customer", "Available", "Selected",
                 choices()[-26], choices()[26], size = 10, multiple = TRUE
    )
    
  })
  
  output$carrier<-renderUI({
    chooserInput("carrier", "Available", "Selected",
                 choices()[-32], choices()[32], size = 10, multiple = TRUE
    )
    
  })
  
  ####### New Start Here for L1
  output$origin_city<-renderUI({
    chooserInput("origin_city", "Available", "Selected",
                 choices()[-8], choices()[8], size = 10, multiple = TRUE
    )
    
  })
  
  output$dest_city<-renderUI({
    chooserInput("dest_city", "Available", "Selected",
                 choices()[-10], choices()[10], size = 10, multiple = TRUE
    )
    
  })
  
  
  output$orig_sub_region<-renderUI({
    chooserInput("orig_sub_region", "Available", "Selected",
                 choices()[-12], choices()[12], size = 10, multiple = TRUE
    )
    
  })
  
  output$orig_spec_region<-renderUI({
    chooserInput("orig_spec_region", "Available", "Selected",
                 choices()[-13], choices()[13], size = 10, multiple = TRUE
    )
    
  })
  
  output$dest_sub_region<-renderUI({
    chooserInput("dest_sub_region", "Available", "Selected",
                 choices()[-14], choices()[14], size = 10, multiple = TRUE
    )
    
  })
  
  output$dest_spec_region<-renderUI({
    chooserInput("dest_spec_region", "Available", "Selected",
                 choices()[-15], choices()[15], size = 10, multiple = TRUE
    )
    
  })
  
  output$orig_zone<-renderUI({
    chooserInput("orig_zone", "Available", "Selected",
                 choices()[-16], choices()[16], size = 10, multiple = TRUE
    )
    
  })
  
  output$orig_region<-renderUI({
    chooserInput("orig_region", "Available", "Selected",
                 choices()[-17], choices()[17], size = 10, multiple = TRUE
    )
    
  })
  
  output$dest_zone<-renderUI({
    chooserInput("dest_zone", "Available", "Selected",
                 choices()[-18], choices()[18], size = 10, multiple = TRUE
    )
    
  })
  
  output$dest_region<-renderUI({
    chooserInput("dest_region", "Available", "Selected",
                 choices()[-19], choices()[19], size = 10, multiple = TRUE
    )
    
  })
  
  
  output$date<-renderUI({
    a=min(CHR()$Date)
    b=max(CHR()$Date)
    out1 <- dateRangeInput("date_range", "Date Cutoff Ranges:", 
                           start =a, end =b )
    if (!is.null(Read_Settings()[["date_range"]])) updateDateRangeInput(session, inputId= "date_range", start = Read_Settings()[["date_range"]][1], end = Read_Settings()[["date_range"]][2])
    return(out1)
  })
  
  
  
  output$cost_lower<-renderUI({
    a=min(CHR()$Total_Cost)
    b=max(CHR()$Total_Cost)
    c = a
    out1 <- sliderInput("cost_lower", "Lower Total Cost Cutoff:", 
                        min =a , max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["cost_lower"]])) updateSliderInput(session, inputId= "cost_lower", value = Read_Settings()[["cost_lower"]])
    return(out1)
  })
  
  output$cost_upper<-renderUI({
    a=min(CHR()$Total_Cost)
    b=max(CHR()$Total_Cost)
    c = b
    out1 <- sliderInput("cost_upper", "Upper Total Cost Cutoff:", 
                        min = a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["cost_upper"]])) updateSliderInput(session, inputId= "cost_upper", value = Read_Settings()[["cost_upper"]])
    return(out1)
  })
  
  output$miles_lower<-renderUI({
    a=min(CHR()$Total_Mileage)
    b=max(CHR()$Total_Mileage)
    c = a
    out1 <- sliderInput("miles_lower", "Lower Mileage Cutoff:", 
                        min =a , max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["miles_lower"]])) updateSliderInput(session, inputId= "miles_lower", value = Read_Settings()[["miles_lower"]])
    return(out1)
  })
  
  output$miles_upper<-renderUI({
    a=min(CHR()$Total_Mileage)
    b=max(CHR()$Total_Mileage)
    c = b
    out1 <- sliderInput("miles_upper", "Upper Mileage Cutoff:", 
                        min = a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["miles_upper"]])) updateSliderInput(session, inputId= "miles_upper", value = Read_Settings()[["miles_upper"]])
    return(out1)
  })
  
  
  output$RPM_lower<-renderUI({
    a=min(CHR()$RPM,na.rm=T)
    b=max(CHR()$RPM,na.rm=T)
    c = 1
    out1 <- sliderInput("RPM_lower", "Lower RPM Cutoff:", 
                        min =a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["RPM_lower"]])) updateSliderInput(session, inputId= "RPM_lower",  value = Read_Settings()[["RPM_lower"]])
    return(out1)
  })
  
  output$RPM_upper<-renderUI({
    a=min(CHR()$RPM,na.rm=T)
    b=max(CHR()$RPM,na.rm=T)
    c = 5
    
    out1 <- sliderInput("RPM_upper", "Upper RPM Cutoff:", 
                        min = a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["RPM_upper"]])) updateSliderInput(session, inputId= "RPM_upper",value = Read_Settings()[["RPM_upper"]])
    return(out1)
  })
  
  #Lane1 UI element rendering
  
  output$l1_orig_zip<-renderUI({
    dat<-FIL()$Origin_Zip
    orig<-unique(dat)
    orig<-sort(orig)###this removes NA's from the list so we need to add an option in the list for NA's
    comp <- c(as.character(orig), "NA")
    orig<-c(orig,NA)
    selected <- c()
    if (!is.null(Read_Settings()[["l1_orig_zip"]])){
      selected <- orig[which(comp%in%Read_Settings()[["l1_orig_zip"]][["right"]])]
      orig <- orig[which(!comp%in%Read_Settings()[["l1_orig_zip"]][["right"]])]}
    chooserInput("l1_orig_zip", "Available", "Selected",
                 orig, selected, size = 10, multiple = TRUE
    )
  })
  
  output$l1_dest_zip<-renderUI({
    dat<-FIL()$Destination_Zip
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    comp <- c(as.character(dest), "NA")
    dest<-c(dest,NA)
    selected <- c()
    if (!is.null(Read_Settings()[["l1_dest_zip"]])){
      selected <- dest[which(comp%in%Read_Settings()[["l1_dest_zip"]][["right"]])]
      dest <- dest[which(!comp%in%Read_Settings()[["l1_dest_zip"]][["right"]])]}
    chooserInput("l1_dest_zip", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l1_stop_ct<-renderUI({
    dat<-FIL()$Stop_Count
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    comp <- c(as.character(dest), "NA")
    dest<-c(dest,NA)
    unselected <- c()
    if (!is.null(Read_Settings()[["l1_stop_ct"]])){
      unselected <- dest[which(!comp%in%Read_Settings()[["l1_stop_ct"]][["right"]])]
      dest <- dest[which(comp%in%Read_Settings()[["l1_stop_ct"]][["right"]])]}
    chooserInput("l1_stop_ct", "Available", "Selected",
                 unselected, dest, size = 10, multiple = TRUE
    )
    
  })
  

  
  output$l1_orig_state<-renderUI({
    dat<-FIL()$Orig_State
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l1_orig_state"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l1_orig_state"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l1_orig_state"]][["right"]])]}
    chooserInput("l1_orig_state", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  

  
  output$l1_delivery_state<-renderUI({
    dat<-FIL()$Delivery_State
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l1_delivery_state"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l1_delivery_state"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l1_delivery_state"]][["right"]])]}
    chooserInput("l1_delivery_state", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  
  #######
  
  output$l1_origin_city<-renderUI({###NEW###
    dat<-FIL()$Origin_City
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l1_origin_city"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l1_origin_city"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l1_origin_city"]][["right"]])]}
    chooserInput("l1_origin_city", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l1_orig_sub_region<-renderUI({###NEW###
    dat<-FIL()$Origin_Sub_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l1_orig_sub_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l1_orig_sub_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l1_orig_sub_region"]][["right"]])]}
    chooserInput("l1_orig_sub_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  
  output$l1_dest_sub_region<-renderUI({###NEW###
    dat<-FIL()$Destination_Sub_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l1_dest_sub_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l1_dest_sub_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l1_dest_sub_region"]][["right"]])]}
    chooserInput("l1_dest_sub_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l1_orig_zone<-renderUI({###NEW###
    dat<-FIL()$Origin_Zone
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l1_orig_zone"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l1_orig_zone"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l1_orig_zone"]][["right"]])]}
    chooserInput("l1_orig_zone", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })

  output$l1_dest_zone<-renderUI({###NEW###
    dat<-FIL()$Destination_Zone
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l1_dest_zone"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l1_dest_zone"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l1_dest_zone"]][["right"]])]}
    chooserInput("l1_dest_zone", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l1_dest_city<-renderUI({###NEW###
    dat<-FIL()$Destination_City
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l1_dest_city"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l1_dest_city"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l1_dest_city"]][["right"]])]}
    chooserInput("l1_dest_city", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })

  output$l1_orig_spec_region<-renderUI({###NEW###
    dat<-FIL()$Origin_Spec_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l1_orig_spec_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l1_orig_spec_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l1_orig_spec_region"]][["right"]])]}
    chooserInput("l1_orig_spec_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l1_dest_spec_region<-renderUI({###NEW###
    dat<-FIL()$Destination_Spec_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l1_dest_spec_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l1_dest_spec_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l1_dest_spec_region"]][["right"]])]}
    chooserInput("l1_dest_spec_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l1_orig_region<-renderUI({###NEW###
    dat<-FIL()$Origin_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l1_orig_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l1_orig_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l1_orig_region"]][["right"]])]}
    chooserInput("l1_orig_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l1_dest_region<-renderUI({###NEW###
    dat<-FIL()$Destination_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l1_dest_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l1_dest_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l1_dest_region"]][["right"]])]}
    chooserInput("l1_dest_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  

  
  ##Lane 1 Outlier Removal UI
  #browser()
  output$date1<-renderUI({
    a=min(L1RAW()$Date)
    b=max(L1RAW()$Date)
    out1 <- dateRangeInput("date_range1", "Date Cutoff Ranges:", 
                           start =a, end =b )
    if (!is.null(Read_Settings()[["date_range1"]])) updateDateRangeInput(session, inputId= "date_range1", start = Read_Settings()[["date_range1"]][1], end = Read_Settings()[["date_range1"]][2])
    return(out1)
  })
  
  
  
  output$cost_lower1<-renderUI({
    a=min(L1RAW()$Total_Cost)
    b=max(L1RAW()$Total_Cost)
    c = a
    out1 <- sliderInput("cost_lower1", "Lower Total Cost Cutoff:", 
                        min =a , max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["cost_lower1"]])) updateSliderInput(session, inputId= "cost_lower1", value = Read_Settings()[["cost_lower1"]])
    return(out1)
  })
  
  output$cost_upper1<-renderUI({
    a=min(L1RAW()$Total_Cost)
    b=max(L1RAW()$Total_Cost)
    c = b
    out1 <- sliderInput("cost_upper1", "Upper Total Cost Cutoff:", 
                        min = a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["cost_upper1"]])) updateSliderInput(session, inputId= "cost_upper1", value = Read_Settings()[["cost_upper1"]])
    return(out1)
  })
  
  output$miles_lower1<-renderUI({
    a=min(L1RAW()$Total_Mileage)
    b=max(L1RAW()$Total_Mileage)
    c = a
    out1 <- sliderInput("miles_lower1", "Lower Mileage Cutoff:", 
                        min =a , max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["miles_lower1"]])) updateSliderInput(session, inputId= "miles_lower1", value = Read_Settings()[["miles_lower1"]])
    return(out1)
  })
  
  output$miles_upper1<-renderUI({
    a=min(L1RAW()$Total_Mileage)
    b=max(L1RAW()$Total_Mileage)
    c = b
    out1 <- sliderInput("miles_upper1", "Upper Mileage Cutoff:", 
                        min = a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["miles_upper1"]])) updateSliderInput(session, inputId= "miles_upper1", value = Read_Settings()[["miles_upper1"]])
    return(out1)
  })
  
  
  output$RPM_lower1<-renderUI({
    a=min(L1RAW()$RPM,na.rm=T)
    b=max(L1RAW()$RPM,na.rm=T)
    c = a
    out1 <- sliderInput("RPM_lower1", "Lower RPM Cutoff:", 
                        min =a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["RPM_lower1"]])) updateSliderInput(session, inputId= "RPM_lower1",  value = Read_Settings()[["RPM_lower1"]])
    return(out1)
  })
  
  output$RPM_upper1<-renderUI({
    a=min(L1RAW()$RPM,na.rm=T)
    b=max(L1RAW()$RPM,na.rm=T)
    c = b
    
    out1 <- sliderInput("RPM_upper1", "Upper RPM Cutoff:", 
                        min = a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["RPM_upper1"]])) updateSliderInput(session, inputId= "RPM_upper1",value = Read_Settings()[["RPM_upper1"]])
    return(out1)
  })
  
  ##Lane 2 data selection
  #Lane1 UI element rendering
  
  output$l2_orig_zip<-renderUI({
    dat<-FIL()$Origin_Zip
    orig<-unique(dat)
    orig<-sort(orig)###this removes NA's from the list so we need to add an option in the list for NA's
    comp <- c(as.character(orig), "NA")
    orig<-c(orig,NA)
    selected <- c()
    if (!is.null(Read_Settings()[["l2_orig_zip"]])){
      selected <- orig[which(comp%in%Read_Settings()[["l2_orig_zip"]][["right"]])]
      orig <- orig[which(!comp%in%Read_Settings()[["l2_orig_zip"]][["right"]])]}
    chooserInput("l2_orig_zip", "Available", "Selected",
                 orig, selected, size = 10, multiple = TRUE
    )
  })
  
  output$l2_dest_zip<-renderUI({
    dat<-FIL()$Destination_Zip
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    comp <- c(as.character(dest), "NA")
    dest<-c(dest,NA)
    selected <- c()
    if (!is.null(Read_Settings()[["l2_dest_zip"]])){
      selected <- dest[which(comp%in%Read_Settings()[["l2_dest_zip"]][["right"]])]
      dest <- dest[which(!comp%in%Read_Settings()[["l2_dest_zip"]][["right"]])]}
    chooserInput("l2_dest_zip", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l2_stop_ct<-renderUI({
    dat<-FIL()$Stop_Count
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    comp <- c(as.character(dest), "NA")
    dest<-c(dest,NA)
    unselected <- c()
    if (!is.null(Read_Settings()[["l2_stop_ct"]])){
      unselected <- dest[which(!comp%in%Read_Settings()[["l2_stop_ct"]][["right"]])]
      dest <- dest[which(comp%in%Read_Settings()[["l2_stop_ct"]][["right"]])]}
    chooserInput("l2_stop_ct", "Available", "Selected",
                 unselected, dest, size = 10, multiple = TRUE
    )
    
  })
  
  
  
  output$l2_orig_state<-renderUI({
    dat<-FIL()$Orig_State
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l2_orig_state"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l2_orig_state"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l2_orig_state"]][["right"]])]}
    chooserInput("l2_orig_state", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  
  
  output$l2_delivery_state<-renderUI({
    dat<-FIL()$Delivery_State
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l2_delivery_state"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l2_delivery_state"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l2_delivery_state"]][["right"]])]}
    chooserInput("l2_delivery_state", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  
  #######
  
  output$l2_origin_city<-renderUI({###NEW###
    dat<-FIL()$Origin_City
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l2_origin_city"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l2_origin_city"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l2_origin_city"]][["right"]])]}
    chooserInput("l2_origin_city", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l2_orig_sub_region<-renderUI({###NEW###
    dat<-FIL()$Origin_Sub_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l2_orig_sub_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l2_orig_sub_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l2_orig_sub_region"]][["right"]])]}
    chooserInput("l2_orig_sub_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  
  output$l2_dest_sub_region<-renderUI({###NEW###
    dat<-FIL()$Destination_Sub_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l2_dest_sub_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l2_dest_sub_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l2_dest_sub_region"]][["right"]])]}
    chooserInput("l2_dest_sub_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l2_orig_zone<-renderUI({###NEW###
    dat<-FIL()$Origin_Zone
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l2_orig_zone"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l2_orig_zone"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l2_orig_zone"]][["right"]])]}
    chooserInput("l2_orig_zone", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l2_dest_zone<-renderUI({###NEW###
    dat<-FIL()$Destination_Zone
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l2_dest_zone"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l2_dest_zone"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l2_dest_zone"]][["right"]])]}
    chooserInput("l2_dest_zone", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l2_dest_city<-renderUI({###NEW###
    dat<-FIL()$Destination_City
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l2_dest_city"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l2_dest_city"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l2_dest_city"]][["right"]])]}
    chooserInput("l2_dest_city", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l2_orig_spec_region<-renderUI({###NEW###
    dat<-FIL()$Origin_Spec_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l2_orig_spec_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l2_orig_spec_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l2_orig_spec_region"]][["right"]])]}
    chooserInput("l2_orig_spec_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l2_dest_spec_region<-renderUI({###NEW###
    dat<-FIL()$Destination_Spec_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l2_dest_spec_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l2_dest_spec_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l2_dest_spec_region"]][["right"]])]}
    chooserInput("l2_dest_spec_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l2_orig_region<-renderUI({###NEW###
    dat<-FIL()$Origin_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l2_orig_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l2_orig_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l2_orig_region"]][["right"]])]}
    chooserInput("l2_orig_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l2_dest_region<-renderUI({###NEW###
    dat<-FIL()$Destination_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l2_dest_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l2_dest_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l2_dest_region"]][["right"]])]}
    chooserInput("l2_dest_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  
  ##Lane 2 Outlier Removal UI
  output$date2<-renderUI({
    a=min(L2RAW()$Date)
    b=max(L2RAW()$Date)
    out1 <- dateRangeInput("date_range2", "Date Cutoff Ranges:", 
                           start =a, end =b )
    if (!is.null(Read_Settings()[["date_range2"]])) updateDateRangeInput(session, inputId= "date_range2", start = Read_Settings()[["date_range2"]][1], end = Read_Settings()[["date_range2"]][2])
    return(out1)
  })
  
  
  
  output$cost_lower2<-renderUI({
    a=min(L2RAW()$Total_Cost)
    b=max(L2RAW()$Total_Cost)
    c = a
    out1 <- sliderInput("cost_lower2", "Lower Total Cost Cutoff:", 
                        min =a , max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["cost_lower2"]])) updateSliderInput(session, inputId= "cost_lower2", value = Read_Settings()[["cost_lower2"]])
    return(out1)
  })
  
  output$cost_upper2<-renderUI({
    a=min(L2RAW()$Total_Cost)
    b=max(L2RAW()$Total_Cost)
    c = b
    out1 <- sliderInput("cost_upper2", "Upper Total Cost Cutoff:", 
                        min = a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["cost_upper2"]])) updateSliderInput(session, inputId= "cost_upper2", value = Read_Settings()[["cost_upper2"]])
    return(out1)
  })
  
  output$miles_lower2<-renderUI({
    a=min(L2RAW()$Total_Mileage)
    b=max(L2RAW()$Total_Mileage)
    c = a
    out1 <- sliderInput("miles_lower2", "Lower Mileage Cutoff:", 
                        min =a , max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["miles_lower2"]])) updateSliderInput(session, inputId= "miles_lower2", value = Read_Settings()[["miles_lower2"]])
    return(out1)
  })
  
  output$miles_upper2<-renderUI({
    a=min(L2RAW()$Total_Mileage)
    b=max(L2RAW()$Total_Mileage)
    c = b
    out1 <- sliderInput("miles_upper2", "Upper Mileage Cutoff:", 
                        min = a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["miles_upper2"]])) updateSliderInput(session, inputId= "miles_upper2", value = Read_Settings()[["miles_upper2"]])
    return(out1)
  })
  
  
  output$RPM_lower2<-renderUI({
    a=min(L2RAW()$RPM,na.rm=T)
    b=max(L2RAW()$RPM,na.rm=T)
    c = a
    out1 <- sliderInput("RPM_lower2", "Lower RPM Cutoff:", 
                        min =a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["RPM_lower2"]])) updateSliderInput(session, inputId= "RPM_lower2",  value = Read_Settings()[["RPM_lower2"]])
    return(out1)
  })
  
  output$RPM_upper2<-renderUI({
    a=min(L2RAW()$RPM,na.rm=T)
    b=max(L2RAW()$RPM,na.rm=T)
    c = b
    
    out1 <- sliderInput("RPM_upper2", "Upper RPM Cutoff:", 
                        min = a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["RPM_upper2"]])) updateSliderInput(session, inputId= "RPM_upper2",value = Read_Settings()[["RPM_upper2"]])
    return(out1)
  })
  
  #Lane 3 data selection inputs
  
  output$l3_orig_zip<-renderUI({
    dat<-FIL()$Origin_Zip
    orig<-unique(dat)
    orig<-sort(orig)###this removes NA's from the list so we need to add an option in the list for NA's
    comp <- c(as.character(orig), "NA")
    orig<-c(orig,NA)
    selected <- c()
    if (!is.null(Read_Settings()[["l3_orig_zip"]])){
      selected <- orig[which(comp%in%Read_Settings()[["l3_orig_zip"]][["right"]])]
      orig <- orig[which(!comp%in%Read_Settings()[["l3_orig_zip"]][["right"]])]}
    chooserInput("l3_orig_zip", "Available", "Selected",
                 orig, selected, size = 10, multiple = TRUE
    )
  })
  
  output$l3_dest_zip<-renderUI({
    dat<-FIL()$Destination_Zip
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    comp <- c(as.character(dest), "NA")
    dest<-c(dest,NA)
    selected <- c()
    if (!is.null(Read_Settings()[["l3_dest_zip"]])){
      selected <- dest[which(comp%in%Read_Settings()[["l3_dest_zip"]][["right"]])]
      dest <- dest[which(!comp%in%Read_Settings()[["l3_dest_zip"]][["right"]])]}
    chooserInput("l3_dest_zip", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l3_stop_ct<-renderUI({
    dat<-FIL()$Stop_Count
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    comp <- c(as.character(dest), "NA")
    dest<-c(dest,NA)
    unselected <- c()
    if (!is.null(Read_Settings()[["l3_stop_ct"]])){
      unselected <- dest[which(!comp%in%Read_Settings()[["l3_stop_ct"]][["right"]])]
      dest <- dest[which(comp%in%Read_Settings()[["l3_stop_ct"]][["right"]])]}
    chooserInput("l3_stop_ct", "Available", "Selected",
                 unselected, dest, size = 10, multiple = TRUE
    )
    
  })
  
  
  
  output$l3_orig_state<-renderUI({
    dat<-FIL()$Orig_State
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l3_orig_state"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l3_orig_state"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l3_orig_state"]][["right"]])]}
    chooserInput("l3_orig_state", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  
  
  output$l3_delivery_state<-renderUI({
    dat<-FIL()$Delivery_State
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l3_delivery_state"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l3_delivery_state"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l3_delivery_state"]][["right"]])]}
    chooserInput("l3_delivery_state", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  
  #######
  
  output$l3_origin_city<-renderUI({###NEW###
    dat<-FIL()$Origin_City
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l3_origin_city"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l3_origin_city"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l3_origin_city"]][["right"]])]}
    chooserInput("l3_origin_city", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l3_orig_sub_region<-renderUI({###NEW###
    dat<-FIL()$Origin_Sub_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l3_orig_sub_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l3_orig_sub_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l3_orig_sub_region"]][["right"]])]}
    chooserInput("l3_orig_sub_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  
  output$l3_dest_sub_region<-renderUI({###NEW###
    dat<-FIL()$Destination_Sub_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l3_dest_sub_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l3_dest_sub_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l3_dest_sub_region"]][["right"]])]}
    chooserInput("l3_dest_sub_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l3_orig_zone<-renderUI({###NEW###
    dat<-FIL()$Origin_Zone
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l3_orig_zone"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l3_orig_zone"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l3_orig_zone"]][["right"]])]}
    chooserInput("l3_orig_zone", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l3_dest_zone<-renderUI({###NEW###
    dat<-FIL()$Destination_Zone
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l3_dest_zone"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l3_dest_zone"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l3_dest_zone"]][["right"]])]}
    chooserInput("l3_dest_zone", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l3_dest_city<-renderUI({###NEW###
    dat<-FIL()$Destination_City
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l3_dest_city"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l3_dest_city"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l3_dest_city"]][["right"]])]}
    chooserInput("l3_dest_city", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l3_orig_spec_region<-renderUI({###NEW###
    dat<-FIL()$Origin_Spec_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l3_orig_spec_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l3_orig_spec_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l3_orig_spec_region"]][["right"]])]}
    chooserInput("l3_orig_spec_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l3_dest_spec_region<-renderUI({###NEW###
    dat<-FIL()$Destination_Spec_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l3_dest_spec_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l3_dest_spec_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l3_dest_spec_region"]][["right"]])]}
    chooserInput("l3_dest_spec_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l3_orig_region<-renderUI({###NEW###
    dat<-FIL()$Origin_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l3_orig_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l3_orig_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l3_orig_region"]][["right"]])]}
    chooserInput("l3_orig_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  output$l3_dest_region<-renderUI({###NEW###
    dat<-FIL()$Destination_Region
    dest<-unique(dat)
    dest<-sort(dest)###this removes NA's from the list so we need to add an option in the list for NA's
    selected <- c()
    if (!is.null(Read_Settings()[["l3_dest_region"]])){
      selected <- dest[which(dest%in%Read_Settings()[["l3_dest_region"]][["right"]])]
      dest <- dest[which(!dest%in%Read_Settings()[["l3_dest_region"]][["right"]])]}
    chooserInput("l3_dest_region", "Available", "Selected",
                 dest, selected, size = 10, multiple = TRUE
    )
    
  })
  
  ##Lane 3 Outlier Removal UI
  output$date3<-renderUI({
    a=min(L3RAW()$Date)
    b=max(L3RAW()$Date)
    out1 <- dateRangeInput("date_range3", "Date Cutoff Ranges:", 
                           start =a, end =b )
    if (!is.null(Read_Settings()[["date_range3"]])) updateDateRangeInput(session, inputId= "date_range3", start = Read_Settings()[["date_range3"]][1], end = Read_Settings()[["date_range3"]][2])
    return(out1)
  })
  
  
  
  output$cost_lower3<-renderUI({
    a=min(L3RAW()$Total_Cost)
    b=max(L3RAW()$Total_Cost)
    c = a
    out1 <- sliderInput("cost_lower3", "Lower Total Cost Cutoff:", 
                        min =a , max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["cost_lower3"]])) updateSliderInput(session, inputId= "cost_lower3", value = Read_Settings()[["cost_lower3"]])
    return(out1)
  })
  
  output$cost_upper3<-renderUI({
    a=min(L3RAW()$Total_Cost)
    b=max(L3RAW()$Total_Cost)
    c = b
    out1 <- sliderInput("cost_upper3", "Upper Total Cost Cutoff:", 
                        min = a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["cost_upper3"]])) updateSliderInput(session, inputId= "cost_upper3", value = Read_Settings()[["cost_upper3"]])
    return(out1)
  })
  
  output$miles_lower3<-renderUI({
    a=min(L3RAW()$Total_Mileage)
    b=max(L3RAW()$Total_Mileage)
    c = a
    out1 <- sliderInput("miles_lower3", "Lower Mileage Cutoff:", 
                        min =a , max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["miles_lower3"]])) updateSliderInput(session, inputId= "miles_lower3", value = Read_Settings()[["miles_lower3"]])
    return(out1)
  })
  
  output$miles_upper3<-renderUI({
    a=min(L3RAW()$Total_Mileage)
    b=max(L3RAW()$Total_Mileage)
    c = b
    out1 <- sliderInput("miles_upper3", "Upper Mileage Cutoff:", 
                        min = a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["miles_upper3"]])) updateSliderInput(session, inputId= "miles_upper3", value = Read_Settings()[["miles_upper3"]])
    return(out1)
  })
  
  
  output$RPM_lower3<-renderUI({
    a=min(L3RAW()$RPM,na.rm=T)
    b=max(L3RAW()$RPM,na.rm=T)
    c = a
    out1 <- sliderInput("RPM_lower3", "Lower RPM Cutoff:", 
                        min =a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["RPM_lower3"]])) updateSliderInput(session, inputId= "RPM_lower3",  value = Read_Settings()[["RPM_lower3"]])
    return(out1)
  })
  
  output$RPM_upper3<-renderUI({
    a=min(L3RAW()$RPM,na.rm=T)
    b=max(L3RAW()$RPM,na.rm=T)
    c = b
    
    out1 <- sliderInput("RPM_upper3", "Upper RPM Cutoff:", 
                        min = a, max = b, value = c, step= NULL)
    if (!is.null(Read_Settings()[["RPM_upper3"]])) updateSliderInput(session, inputId= "RPM_upper3",value = Read_Settings()[["RPM_upper3"]])
    return(out1)
  })
  
  #Working UI elements for bundles 3, 4, & 5
  
  output$min_lead_slider <- renderUI({
    out1 <- sliderInput(inputId = "min_lead",
                        label = "Minimum Lead to Fit (in days)",
                        min = 0,
                        max = 36,
                        value = 0,
                        step = 1
    )
    if (!is.null(Read_Settings()[["min_lead"]])) updateSliderInput(session, inputId= "min_lead", value = Read_Settings()[["min_lead"]])
    return(out1)
  })
  
  output$max_lead_slider <- renderUI({
    out1 <- sliderInput(inputId="max_lead",
                        label="Maximum Lead to Fit (in days)",
                        min=0,
                        max=36,
                        value=0,
                        step=1                
    )
    if (!is.null(Read_Settings()[["max_lead"]])) updateSliderInput(session, inputId= "max_lead", value = Read_Settings()[["max_lead"]])
    return(out1)
  })
  
  output$max_model_slider <- renderUI({
    out1 <- sliderInput(inputId="max_model",
                        label="Number of Variables in Model",
                        min=1,
                        max=10,
                        value=1,
                        step=1                
    )
    if (!is.null(Read_Settings()[["max_model"]])) updateSliderInput(session, inputId= "max_model", value = Read_Settings()[["max_model"]])
    return(out1)
  })
  
  output$backcast_ahead_slider <- renderUI({
    datset <- FINAL()
    datset<-datset[gsub(" ", "\\.", datset[["Constructed_Lane"]]) %in% gsub(".RPM","", input$response),]
    preddat <- max(datset[["Date"]])
    out1 <- dateInput(inputId="backcast_ahead",
                      label= paste0("Predict from End of Historical Data (", preddat, ") to:"),
                      min=preddat + 1,
                      max=preddat + 365,
                      value=preddat + 365                
    )
    if (!is.null(Read_Settings()[["backcast_ahead"]])) updateDateInput(session, inputId= "backcast_ahead", value = Read_Settings()[["backcast_ahead"]])
    return(out1)
  })
  
  pred_length <- reactive({
    datset <- FINAL()
    datset<-datset[gsub(" ", "\\.", datset[["Constructed_Lane"]]) %in% gsub(".RPM","", input$response),]
    preddat <- max(datset[["Date"]])
    out <- as.numeric(input$backcast_ahead - preddat)
    return(out)
    
  })
  
  output$backcast_length_slider <- renderUI({
    out1 <- sliderInput(inputId = "backcast_length",
                        label = "Length of Backcast Fit (in days)",
                        min = 1,
                        max = 365,
                        value = 52,
                        step = 1                
    )
    if (!is.null(Read_Settings()[["backcast_length"]])) updateSliderInput(session, inputId= "backcast_length", value = Read_Settings()[["backcast_length"]])
    return(out1)
  })
  
  output$gamma_numeric <- renderUI({
    numericInput(inputId="gamma", 
                 label="smooth penalty:", 
                 value=1.4
                 
    )
  })
  
  output$interaction_split <- renderUI({
    numericInput(inputId="interaction_split", 
                 label="Day to Split First/Second Half of Season for Interaction:", 
                 value=182,min=1,max=365,step=1
                 
    )
  })
  
  output$pick_numeric <- renderUI({
    numericInput(inputId="pick", 
                 label="Variable to Pick to Add to Model:", 
                 value=1
                 
    )
  })
  
  output$interaction_check <- renderUI({
    checkboxInput(inputId = "interaction",
                  label = "1/2 year Interaction for Volume Terms?",
                  value=FALSE
    )
  })
  
  output$seasonality <- renderUI({
    checkboxInput(inputId = "seasonality",
                  label = "Estimate Seasonality?",
                  value=TRUE
    )
  })
  
  output$linear <- renderUI({
    checkboxInput(inputId = "linear",
                  label = "Estimate Inflation?",
                  value=TRUE
    )
  })
  
  output$predictors_checkgroup <- renderUI({
    x <-data.frame(LANE_BUNDLE()[['DATA_FILL']])
    date <-x$Align_date
    date_cols<-grep("date",colnames(x))
    x<-x[,-date_cols]
    colnames(x)<-gsub("_data","",colnames(x))
    sel=NULL
    choice<-colnames(x)
    if (!is.null(Read_Settings())){
      sel <- choice[which(choice%in%Read_Settings()[["predictors"]])]}
    checkboxGroupInput(inputId = "predictors",
                       label = "Select Predictors",
                       choices = choice, selected=sel
    )
  })
  
  
  output$volume_checkgroup <- renderUI({
    x <-data.frame(LANE_BUNDLE()[['DATA_FILL']])
    date <-x$Align_date
    date_cols<-grep("date",colnames(x))
    x<-x[,-date_cols]
    colnames(x)<-gsub("_data","",colnames(x))
    choice<-colnames(x)
    choice<-choice[grep("volume",choice)]
    sel<- choice[1]
    if (!is.null(Read_Settings())){
      sel <- choice[which(choice%in%Read_Settings()[["volume"]])]}
    checkboxGroupInput(inputId = "volume",
                       label = "Select Prediction Lane Volume",
                       choices = choice, selected=sel
    )
  })
  
  output$response_radio <- renderUI({
    x <-data.frame(LANE_BUNDLE()[['DATA_FILL']])
    date <-x$Align_date
    date_cols<-grep("date",colnames(x))
    x<-x[,-date_cols]
    colnames(x)<-gsub("_data","",colnames(x))
    

    choice<-colnames(x)
    choice_r<-choice[grep("RPM",colnames(x))]
    sel_r<-choice_r[choice_r %in% paste(gsub("\\s", ".", input$lane1_id),".RPM",sep="")]
    
    if (!is.null(Read_Settings()[["response"]])){
      sel_r <- choice_r[which(choice_r%in%Read_Settings()[["response"]])]}
    radioButtons(inputId = "response",
                 label = "Select Response",
                 choices = choice_r, selected=sel_r
    )
  })
  
  output$select_radio <- renderUI({
    PLOT=LANE_BUNDLE()[['PLOT']]
    choice3<-as.list(unique(PLOT$group))
    names(choice3)<-unique(PLOT$group)
    choice3 <- names(choice3)
    sel <- choice3[1]
    if (!is.null(Read_Settings()[["select"]])){
      sel <- choice3[which(choice3%in%Read_Settings()[["select"]])]}
    radioButtons(inputId = "select",
                 label = "Data Selection for Plot",
                 choices = choice3,
                 selected = sel
    )
  })
  
  output$LCL_percentile<- renderUI({
    out1 <- sliderInput(inputId = "LCL_percentile",
                        label = "Percentile for Lower Confidence Inerval (%)",
                        min = 60,
                        max = 99,
                        value = 95,
                        step = 1                
    )
    if (!is.null(Read_Settings()[["LCL_percentile"]])) updateSliderInput(session, inputId= "LCL_percentile", value = Read_Settings()[["LCL_percentile"]])
    return(out1)
  })
  
  output$UCL_percentile<- renderUI({
    out1 <- sliderInput(inputId = "UCL_percentile",
                        label = "Percentile for Upper Confidence Inerval (%)",
                        min = 60,
                        max = 99,
                        value = 95,
                        step = 1                
    )
    if (!is.null(Read_Settings()[["UCL_percentile"]])) updateSliderInput(session, inputId= "UCL_percentile", value = Read_Settings()[["UCL_percentile"]])
    return(out1)
  })
  
  ##############Inputs for report selection
  
  output$report_rate_graph <- renderUI({
    checkboxInput(inputId = "report_rate_graph",
                  label = "Include Graph of Historical and Predicted Rate",
                  value=TRUE
    )
})
    
    output$report_historic_graph <- renderUI({
      checkboxInput(inputId = "report_historic_graph",
                    label = "Include Graph of Quote Values From Previous Years",
                    value=TRUE
      )
    })

output$report_quote_table <- renderUI({
  checkboxInput(inputId = "report_quote_table",
                label = "Include Table of Quote Values From Previous Years",
                value=TRUE
  )
})

#  output$report_preview <- renderUI({ list(
#    knit2html("report.Rmd")
#  )})

  ######################################################################################
  ########################### FUCK           ###################################
  ######################################################################################
  output$quote_date<-renderUI({
    smooth_vals<-mod()[["smooth_data"]]
    idxx<-smooth_vals[[5]]=="observed"
    datevect <- smooth_vals[[1]][!idxx]
    a=min(datevect)
    b=max(datevect)
    out1 <- dateRangeInput("quote_date", "Date Cutoff Ranges for Integrated Quote:", 
                   start =a, end =b )
    if (!is.null(Read_Settings()[["quote_date"]])) updateDateRangeInput(session, inputId= "quote_date", start = Read_Settings()[["quote_date"]][1], end = Read_Settings()[["quote_date"]][2])
    return(out1)
  })
  
  
  output$matrix_volume <- renderUI({
    smooth_vals<-mod()[["smooth_data"]]
    vol_vals<-vol_integrator()
    datevect <- smooth_vals[[1]]
    idx<-datevect>=input$quote_date[1] & datevect<=input$quote_date[2]
    idxx<-smooth_vals[[5]]=="observed"
    datatrans <- matrix(NA,nrow=nrow(smooth_vals),ncol = 3)
    #datatrans[idxx,1] <- smooth_vals[[2]][idxx]
    datatrans[idxx,1] <- vol_vals[[2]][idxx]
    datatrans[!idxx,3] <- smooth_vals[[2]][!idxx]
    datatrans[!idxx,2] <- vol_vals[[2]][!idxx]
    matrix_preds<-data.frame("Date"=datevect[!idxx],"RPM"=round(datatrans[!idxx,3],2),"Volume"=round(datatrans[!idxx,2],2))
    if (!is.null(Read_Settings()[["matrix_volume"]])){
      matrix_preds<-data.frame(Read_Settings()[["matrix_volume"]])
    }
    matrixCustom('matrix_volume', 'Future Values For Quote Construction',matrix_preds)
    ###you can access these values with input$matrix_volume as the variable anywhere in the server side file
    
  })
  #######################################################################################################
  #######################################################################################################
  #######################################################################################################
  
output$load_dates <- renderUI({
  checkboxInput(inputId = "load_dates",
                label = "Load Dates from Settings File",
                value=TRUE
  )
})

output$load_outlier <- renderUI({
  checkboxInput(inputId = "load_outlier",
                label = "Load Data Selection Parameters from Settings File",
                value=TRUE
  )
})

output$load_model <- renderUI({
  checkboxInput(inputId = "load_model",
                label = "Load Model Settings from Settings File",
                value=TRUE
  )
})
  
  
  #################################################################################################################################
  #################################### Bundle 1 data processing insertion point#########
  ##################################################################################################################################
  
  Read_Settings <- reactive({
    inFile <- input$settings_file
    if (is.null(inFile)) return(NULL)
    load(inFile$datapath)
    
    ##### Options for settings loader on which inputs to load from save file ######################################
    
    ## Remove saved date settings ##
    
    if (input$load_dates == FALSE){
    
      saved_settings$date_range = NULL
      saved_settings$date_range1 = NULL
      saved_settings$quote_date = NULL
      
      
    }
    
    if(input$load_outlier == FALSE){
      
      saved_settings$cost_lower = NULL
      saved_settings$cost_upper = NULL
      saved_settings$miles_lower = NULL
      saved_settings$miles_upper = NULL
      saved_settings$RPM_lower = NULL
      saved_settings$RPM_upper = NULL
      
      saved_settings$lane1_id = NULL
      saved_settings$l1_stop_count = NULL
      saved_settings$stop_table1 = NULL
      saved_settings$l1_orig_zip = NULL
      saved_settings$l1_orig_state = NULL
      saved_settings$l1_load_region = NULL
      saved_settings$l1_dest_zip = NULL
      saved_settings$l1_delivery_state = NULL
      saved_settings$l1_delivery_region = NULL
      saved_settings$l1_origin_city = NULL
      saved_settings$l1_orig_sub_region = NULL
      saved_settings$l1_dest_sub_region = NULL
      saved_settings$l1_orig_zone = NULL
      saved_settings$l1_dest_zone = NULL
      saved_settings$l1_dest_city = NULL
      saved_settings$l1_orig_spec_region = NULL
      saved_settings$l1_dest_spec_region = NULL
      saved_settings$l1_orig_region = NULL
      saved_settings$l1_dest_region = NULL
      
      saved_settings$cost_lower1 = NULL
      saved_settings$cost_upper1 = NULL
      saved_settings$miles_lower1 = NULL
      saved_settings$miles_upper1 = NULL
      saved_settings$RPM_lower1 = NULL
      saved_settings$RPM_upper1 = NULL
      saved_settings$L1_CLEANUP = NULL
      saved_settings$remove_selected_l1 = NULL
      saved_settings$removal_type_l1 = NULL
      saved_settings$salvage_L1 = NULL
      saved_settings$threshold_L1 = NULL
      saved_settings$ratio_cut_L1 = NULL
      saved_settings$tree_select_nsplit_L1 = NULL
      saved_settings$tree_adjust_L1 = NULL
      
      saved_settings$lane2_id = NULL
      saved_settings$l2_stop_count = NULL
      saved_settings$stop_table2 = NULL
      saved_settings$l2_orig_zip = NULL
      saved_settings$l2_orig_state = NULL
      saved_settings$l2_load_region = NULL
      saved_settings$l2_dest_zip = NULL
      saved_settings$l2_delivery_state = NULL
      saved_settings$l2_delivery_region = NULL
      saved_settings$l2_origin_city = NULL
      saved_settings$l2_orig_sub_region = NULL
      saved_settings$l2_dest_sub_region = NULL
      saved_settings$l2_orig_zone = NULL
      saved_settings$l2_dest_zone = NULL
      saved_settings$l2_dest_city = NULL
      saved_settings$l2_orig_spec_region = NULL
      saved_settings$l2_dest_spec_region = NULL
      saved_settings$l2_orig_region = NULL
      saved_settings$l2_dest_region = NULL
      
      saved_settings$cost_lower2 = NULL
      saved_settings$cost_upper2 = NULL
      saved_settings$miles_lower2 = NULL
      saved_settings$miles_upper2 = NULL
      saved_settings$RPM_lower2 = NULL
      saved_settings$RPM_upper2 = NULL
      saved_settings$L2_CLEANUP = NULL
      saved_settings$remove_selected_l2 = NULL
      saved_settings$removal_type_l2 = NULL
      saved_settings$salvage_L2 = NULL
      saved_settings$threshold_L2 = NULL
      saved_settings$ratio_cut_L2 = NULL
      saved_settings$tree_select_nsplit_L2 = NULL
      saved_settings$tree_adjust_L2 = NULL
      
      saved_settings$lane3_id = NULL
      saved_settings$l3_stop_count = NULL
      saved_settings$stop_table3 = NULL
      saved_settings$l3_orig_zip = NULL
      saved_settings$l3_orig_state = NULL
      saved_settings$l3_load_region = NULL
      saved_settings$l3_dest_zip = NULL
      saved_settings$l3_delivery_state = NULL
      saved_settings$l3_delivery_region = NULL
      saved_settings$l3_origin_city = NULL
      saved_settings$l3_orig_sub_region = NULL
      saved_settings$l3_dest_sub_region = NULL
      saved_settings$l3_orig_zone = NULL
      saved_settings$l3_dest_zone = NULL
      saved_settings$l3_dest_city = NULL
      saved_settings$l3_orig_spec_region = NULL
      saved_settings$l3_dest_spec_region = NULL
      saved_settings$l3_orig_region = NULL
      saved_settings$l3_dest_region = NULL
      
      saved_settings$cost_lower3 = NULL
      saved_settings$cost_upper3 = NULL
      saved_settings$miles_lower3 = NULL
      saved_settings$miles_upper3 = NULL
      saved_settings$RPM_lower3 = NULL
      saved_settings$RPM_upper3 = NULL
      saved_settings$L3_CLEANUP = NULL
      saved_settings$remove_selected_l3 = NULL
      saved_settings$removal_type_l3 = NULL
      saved_settings$salvage_L3 = NULL
      saved_settings$threshold_L3 = NULL
      saved_settings$ratio_cut_L3 = NULL
      saved_settings$tree_select_nsplit_L3 = NULL
      saved_settings$tree_adjust_L3 = NULL
    }
    
    if (input$load_model == FALSE){
      
      saved_settings$select = NULL
      saved_settings$min_lead = NULL
      saved_settings$max_lead = NULL
      saved_settings$max_model = NULL
      saved_settings$gamma = NULL
      saved_settings$backcast_ahead = NULL
      saved_settings$pick = NULL
      saved_settings$linear = NULL
      saved_settings$seasonality = NULL
      saved_settings$interaction = NULL
      saved_settings$interaction_split = NULL
      saved_settings$add_stop_ct = NULL
      saved_settings$response = NULL
      saved_settings$predictors = NULL
      saved_settings$LCL_percentile = NULL
      saved_settings$UCL_percentile = NULL
      saved_settings$carry_forward = NULL
      saved_settings$undopredclick = NULL
      saved_settings$table_values = NULL
      saved_settings$settings_name = NULL
      saved_settings$report_quote_table = NULL
      saved_settings$report_rate_graph = NULL
      saved_settings$report_historic_graph = NULL
      saved_settings$format = NULL
      saved_settings$backcast_length = NULL
      saved_settings$matrix_volume = NULL
      saved_settings$pred_fwd = NULL
      saved_settings$final_tree_message = NULL
      saved_settings$final_stop_table_message = NULL
      
    }
    
    #### Remove model selection settings #######
    
    return(saved_settings)
  })
  
  Change_static_settings <- observe({
    if (is.null(Read_Settings())) return(NULL)
    updateSliderInput(session, inputId= "rand_samp",value = Read_Settings()[["rand_samp"]])
    updateNumericInput(session, inputId= "gamma", value = Read_Settings()[["gamma"]])
    updateNumericInput(session, inputId= "interaction_split", value = Read_Settings()[["interaction_split"]])
    updateNumericInput(session, inputId= "pick", value = Read_Settings()[["pick"]])
    updateNumericInput(session, inputId= "threshold_L1", value = Read_Settings()[["threshold_L1"]])
    updateNumericInput(session, inputId= "threshold_L2", value = Read_Settings()[["threshold_L2"]])
    updateNumericInput(session, inputId= "threshold_L3", value = Read_Settings()[["threshold_L3"]])
    updateNumericInput(session, inputId= "ratio_cut_L1", value = Read_Settings()[["ratio_cut_L1"]])
    updateNumericInput(session, inputId= "ratio_cut_L2", value = Read_Settings()[["ratio_cut_L2"]])
    updateNumericInput(session, inputId= "ratio_cut_L3", value = Read_Settings()[["ratio_cut_L3"]])
    updateSelectInput(session, inputId="lanes_choice", selected = Read_Settings()[["lanes_choice"]])
    updateSelectInput(session, inputId="removal_type_l1", selected = Read_Settings()[["removal_type_l1"]])
    updateSelectInput(session, inputId="removal_type_l2", selected = Read_Settings()[["removal_type_l2"]])
    updateSelectInput(session, inputId="removal_type_l3", selected = Read_Settings()[["removal_type_l3"]])
    updateCheckboxInput(session, inputId="interaction", value = Read_Settings()[["interaction"]])
    updateCheckboxInput(session, inputId="seasonality", value = Read_Settings()[["seasonality"]])
    updateCheckboxInput(session, inputId="linear", value = Read_Settings()[["linear"]])
    updateCheckboxInput(session, inputId="carry_forward", value = Read_Settings()[["carry_forward"]])
    updateCheckboxInput(session, inputId="tree_adjust_L1", value = Read_Settings()[["tree_adjust_L1"]])
    updateCheckboxInput(session, inputId="tree_adjust_L2", value = Read_Settings()[["tree_adjust_L2"]])
    updateCheckboxInput(session, inputId="tree_adjust_L3", value = Read_Settings()[["tree_adjust_L3"]])
    updateCheckboxInput(session, inputId="salvage_L1", value = Read_Settings()[["salvage_L1"]])
    updateCheckboxInput(session, inputId="salvage_L2", value = Read_Settings()[["salvage_L2"]])
    updateCheckboxInput(session, inputId="salvage_L3", value = Read_Settings()[["salvage_L3"]])
    updateCheckboxInput(session, inputId= "remove_selected_l1", value = Read_Settings()[["remove_selected_l1"]])
    updateCheckboxInput(session, inputId= "remove_selected_l2", value = Read_Settings()[["remove_selected_l2"]])
    updateCheckboxInput(session, inputId= "remove_selected_l3", value = Read_Settings()[["remove_selected_l3"]])
    updateTextInput(session, inputId= "lane1_id", value = Read_Settings()[["lane1_id"]])
    updateTextInput(session, inputId= "lane2_id", value = Read_Settings()[["lane2_id"]])
    updateTextInput(session, inputId= "lane3_id", value = Read_Settings()[["lane3_id"]])
    
  })
  
  output$downloadData<-downloadHandler(
    filename = function(){paste(input$settings_name,".RData",sep = "")},
    content = function(file){
      saved_settings <- reactiveValuesToList(input)
      save(saved_settings, file = file)
    })
  
  Data<-reactive({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    dat<-fread(inFile$datapath, header=input$header, sep=input$sep, na.strings=c("n/a","XXX"),nrows=-1)
    dat<-as.data.frame(dat)
    #dat<-read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote, na.strings=c("n/a","XXX"),nrows=-1)
    #dat2<-fread(inFile$datapath, na.strings=c("n/a","XXX"),stringsAsFactors=T)
    idx<-sample(1:nrow(dat),size=floor(input$rand_samp*nrow(dat)/100))
    dat<-dat[idx,]
  })
  
  
  ###########################API for Fuel and Economic Indicators ###########################
  output$fuel_econ_active<-renderUI({
    if(is.null(API())){
      h3("You have to Either Click the Browse button to upload a file or Go Get Data from internet button
         (if this message is showing Fuel/Economic indicators are not active)")
    }else{
      return(NULL)
    }
  })
  
  READ_API <- reactive({###use tmp file from disk or specify names of variables to extract
    #if (input$refresh==0 & is.null(input$api_file)){return(NULL)}
    CENSUS=NULL
    FUEL_DATA=NULL
    path=NULL
    inFile <- input$api_file
    if (is.null(inFile)){
      if(file.exists("census_api.csv")){
        api_readtable<-read.csv(header = TRUE, file = "census_api.csv",sep=",")
        apicolnames <- colnames(api_readtable)
        path=NULL
      }else{return(NULL)}
    }else{
      load(inFile$datapath)
      CENSUS=saved_api[["CENSUS"]]
      FUEL_DATA=saved_api[["FUEL_DATA"]]
      api_readtable=saved_api[["api_readtable"]]
      apicolnames <- colnames(api_readtable)
      path=inFile$datapath
    }
    return(structure(list("api_readtable" = api_readtable,"CENSUS"=CENSUS,"FUEL_DATA"=FUEL_DATA,"apicolnames" = apicolnames,"path"=path)))
  })
  
  
  API_Update<-reactive({
    #if (input$refresh==0 & is.null(input$api_file)){return(NULL)}
    if(input$refresh==0 | is.null(isolate(input$api_names))){
      api_readtable <- READ_API()[["api_readtable"]]
    }
    else{
      isolate({
        api_readtable <- data.frame(input$api_names)
        api_readtable<-api_readtable[2:nrow(api_readtable),]
        colnames(api_readtable) <- READ_API()[["apicolnames"]]
      })}
    return(api_readtable)
  })
  
  API<-reactive({
    if (input$refresh==0 & is.null(input$api_file)){return(NULL)}
    CHR<-FINAL()
    api_readtable<-API_Update()
    path<-READ_API()[["path"]]
    CENSUS<-READ_API()[["CENSUS"]]
    FUEL_DATA<-READ_API()[["FUEL_DATA"]]

    
    
    
    fuel_choice<-c("PET.EMD_EPD2D_PTE_NUS_DPG.W","PET.EMD_EPD2D_PTE_R10_DPG.W","PET.EMD_EPD2D_PTE_R1X_DPG.W",
                   "PET.EMD_EPD2D_PTE_R1Y_DPG.W","PET.EMD_EPD2D_PTE_R1Z_DPG.W","PET.EMD_EPD2D_PTE_R20_DPG.W",
                   "PET.EMD_EPD2D_PTE_R30_DPG.W","PET.EMD_EPD2D_PTE_R40_DPG.W","PET.EMD_EPD2D_PTE_R50_DPG.W ",
                   "PET.EMD_EPD2D_PTE_SCA_DPG.W")
    
    if (input$refresh!=0 | is.null(path)){
    FUEL_DATA<-vector("list",length(fuel_choice))
    fuel_names<-character(length(fuel_choice))
    for (beta in 1:length(fuel_choice)){
    Json_fuel<-EPA_API(series=fuel_choice[beta],key="A9BCC61DA44BA0C0ECA4A42D622D7D44")
    date<-c()
    fuel<-c()
    for (i in 1:length(Json_fuel$series[[1]][['data']])){
      date<-c(date,Json_fuel$series[[1]][['data']][[i]][[1]])
      fuel<-c(fuel,Json_fuel$series[[1]][['data']][[i]][[2]])
    }
    FUEL<-data.frame(Date=as.Date(date,format="%Y%m%d"),X=as.numeric(fuel))
    if (beta>=2){
      indx<-FUEL_DATA[[1]][,1] %in% FUEL[,1] 
      FUEL[,2]<-FUEL[,2]-FUEL_DATA[[1]][indx,2]
      colnames(FUEL)[2]<-paste("Diff_from_us_avg",Json_fuel$series[[1]][['name']],sep="_")
    }
    if (beta==1){colnames(FUEL)[2]<-Json_fuel$series[[1]][['name']]}
    FUEL_DATA[[beta]]<-FUEL
    }}
        
    series<-api_readtable
    if (input$refresh!=0 | is.null(path)){CENSUS<-CENSUS_API(series=series,key="cf2bc020b12d020f8ee3155f74198a21dc585845")}
    fuel_length<-length(FUEL_DATA)
    out<-vector("list",length(CENSUS)+fuel_length)##add in a slots for fuel data
    out[1:fuel_length]<-FUEL_DATA
    names(out)<-NA
    names(out)[1:length(FUEL_DATA)]<-fuel_choice
    i=1
    for (i in 1:length(CENSUS)){
      rows<-length(CENSUS[[i]])
      a<-series$path_desc[i]
      b<-series$category_desc[i]
      c<-series$data_type_desc[i]
      name<-paste(a,":",b,"(",c,")",sep="")
      temp_matrix<-t(matrix(unlist(CENSUS[[i]][2:rows]),nrow=5))
      data<-as.numeric(temp_matrix[,1])
      if (length(grep("Q",temp_matrix[1,4]))==0){
        date<-as.Date(paste0(temp_matrix[,4],"-01"),format="%Y-%m-%d")} else{
          tt<-temp_matrix[,4]
          tt<-gsub("Q1","01-01",tt)
          tt<-gsub("Q2","04-01",tt)
          tt<-gsub("Q3","07-01",tt)
          tt<-gsub("Q4","10-01",tt)
          date<-as.Date(tt,format="%Y-%m-%d")
        }
      tp<-data.frame(Date=date,X=data)
      colnames(tp)[2]<-name
      out[[i+fuel_length]]<-tp
      names(out)[i+fuel_length]<-paste(CENSUS[[i]][[2]][2:3],collapse="_")
    }
    Indicators<-out
    
    X<-list()
    for (i in names(Indicators)){
      tmp<-averages(Indicators[[i]],d_index=1)
      X[[i]]<-tmp$DAY[,-c(1,4)]
    }
        

    START=format(min(CHR$Date),format="%Y-%m-%d")
    END=format(Sys.time(),format="%Y-%m-%d")
    DATA_I<-align_day(X,d_index=rep(1,length(ls(X))),start=START,end=END)
    for (i in 2:length(DATA_I)){
      DATA_I[[i]]<-DATA_I[[i]][-c(1)]
    }
    
    #DATA_FILL_I<-loess_fill(DATA_I,t_index=1,span=c(10:1/10),folds=5)
    #DATA_FILL_I<-PIECE_fill(DATA_I,t_index=1)
    
    DATA_FILL_I<-list()
    idx<-names(DATA_I)
    DATA_FILL_I[[idx[1]]]<-DATA_I[[idx[1]]]
    for (i in 2:length(DATA_I)){
      DATA_FILL_I[[idx[i]]]<-na.approx(DATA_I[[idx[i]]],na.rm=FALSE)
    }
    
    list(DATA_I=DATA_I,DATA_FILL_I=DATA_FILL_I,CENSUS=CENSUS,FUEL_DATA=FUEL_DATA,path=path,api_readtable=api_readtable)
  })
  
  
  output$API_SAVE<-downloadHandler(
    filename = function(){paste(input$API_SAVE_NAME,".RData",sep = "")},
    content = function(file){
      saved_api<-API()
      #saved_api <- reactiveValuesToList(tmp)
      save(saved_api, file = file)
    })

  ######################################
  #####Weather Insert Starts Here ######
  ######################################
  output$weather_active<-renderUI({
    if(is.null(WEATHER_STATIONS())){
      h3("You have to click the go lookup weather button (if this message is showing weather is not active)")
    }else{
      return(NULL)
    } 
  })
  
  output$noaa_key<-renderUI({
  textInput("noaa_key","Your API NOAA Key",value="QDqOpowUVBqxuNYLygxnxXXjxFOqaJuy")
  })


WEATHER_API <- reactive({###use tmp file from disk or specify names of variables to extract
  #if (input$refresh==0 & is.null(input$api_file)){return(NULL)}
  station_both_data=NULL
  geocode_result=NULL
  descriptions=NULL
  address=NULL
  map=NULL
  ALL=NULL

  path=NULL
  inFile <- input$weather_file
  if (is.null(inFile)){
    if(file.exists("weather_api.csv")){
      weather_readtable<-read.csv(header = TRUE, file = "weather_api.csv",sep=",")
      weathercolnames <- colnames(weather_readtable)
      path=NULL
    }else{return(NULL)}
  }else{
    load(inFile$datapath)
    station_both_data=saved_weather[["station_both_data"]]
    geocode_result=saved_weather[["geocode_result"]]
    descriptions=saved_weather[["descriptions"]]
    address=saved_weather[["address"]]
    map=saved_weather[["map"]]
    ALL=saved_weather[["ALL"]]
    
    ###add all statements here for save
    
    weather_readtable=saved_weather[["weather_readtable"]]
    weathercolnames <- colnames(weather_readtable)
    path=inFile$datapath
  }
  return(structure(list("weather_readtable" = weather_readtable,station_both_data=station_both_data,
                        geocode_result=geocode_result,descriptions=descriptions,address=address,map=map,
                        ALL=ALL,
                        "weathercolnames" = weathercolnames,"path"=path)))
})


WEATHER_Update<-reactive({
  #if (input$refresh==0 & is.null(input$api_file)){return(NULL)}
  if(input$kick_weather==0 | is.null(isolate(input$weather_names))){
    weather_readtable <- WEATHER_API()[["weather_readtable"]]
  }
  else{
    isolate({
      weather_readtable <- data.frame(input$weather_names,stringsAsFactors = FALSE)
      weather_readtable<-weather_readtable[2:nrow(weather_readtable),]
      colnames(weather_readtable) <- WEATHER_API()[["weathercolnames"]]
    })}
  return(weather_readtable)
})


output$weather_addresses <- renderUI({
  #if (input$refresh==0 & is.null(input$api_file)){return(NULL)}
  weather_readtable <- WEATHER_Update()
  weather_readtable<-data.frame(rbind(toupper(colnames(weather_readtable)),as.matrix(weather_readtable)))
  if (!is.null(Read_Settings()[["weather_names"]])){
    weather_readtable<-data.frame(Read_Settings()[["weather_names"]])
  }
  
  matrixCustom('weather_names', 'Cities to Get Weather For Modeling',weather_readtable)
   
})

  

  
  WEATHER_STATIONS<-reactive({
    if (input$kick_weather==0 & is.null(input$weather_file)){return(NULL)}
    station_both_data=WEATHER_API()[["station_both_data"]]
    geocode_result=WEATHER_API()[["geocode_result"]]
    descriptions=WEATHER_API()[["descriptions"]]
    address=WEATHER_API()[["address"]]
    
    
    if(is.null(input$weather_file)){
    #input$kick_weather###this is to boot it after address or key changes
    weather_readtable<-WEATHER_Update()
    noaakey=isolate(input$noaa_key) ###Mark Albrecht NOAA Key
    
    #####find weather stations meeting the recording requirements######
    descriptions<-weather_readtable[,1]
    address<-weather_readtable[,2]###to be geocoded through googlemaps
    geocode_result<-geocode(address, output="all")###geocode through googlemaps
    if(length(address)==1){###add a nested layer to deal with different API format if address is 1 item
      tmp<-list()
      tmp[[1]]<-geocode_result
      geocode_result<-tmp
    }
    
    extents_box<-list()
    station_daily<-list()
    station_normals<-list()
    station_both_data<-list()
    for (i in 1:length(geocode_result)){
      extents_box[[i]]<-unlist(geocode_result[i][[1]]$results[[1]]$geometry$bounds)[c(3,4,1,2)]
      station_daily[[i]]<-ncdc_stations(token=noaakey,extent=extents_box[[i]],datasetid=c('GHCND'),limit=1000)
      station_normals[[i]]<-ncdc_stations(token=noaakey,extent=extents_box[[i]],datasetid=c("NORMAL_DLY"),limit=1000)
      idx<-station_daily[[i]]$data$id %in% station_normals[[i]]$data$id
      station_both_data[[i]]<-station_daily[[i]]$data[idx,]
    }
    }
    
    return(list(station_both_data=station_both_data,geocode_result=geocode_result,descriptions=descriptions,address=address))
  })
  
  output$stations_table<-renderDataTable({
    if(is.null(WEATHER_STATIONS())){return(NULL)}
    station_both_data<-WEATHER_STATIONS()[["station_both_data"]]
    descriptions<-WEATHER_STATIONS()[["descriptions"]]
    out<-data.frame()
    for (i in 1:length(station_both_data)){
      out<-rbind(out,data.frame("Description"=descriptions[i],station_both_data[[i]]))
    }
    
    out
    
  })
  
    
  output$station_list<- renderUI({
    if(is.null(WEATHER_STATIONS())){return(NULL)}
    station_both_data<-WEATHER_STATIONS()[["station_both_data"]]
    descriptions<-WEATHER_STATIONS()[["descriptions"]]
    
    chosen<-list()
    for (i in 1:length(station_both_data)){
      chosen[[i]]<-station_both_data[[i]][which.max(station_both_data[[i]]$datacoverage),1]
    }
    
    checkbox_output_list <- lapply(1:length(station_both_data), function(i) {
      inputname <- paste("check_group", i, sep="")
      selectInput(inputname, descriptions[i],station_both_data[[i]][,1],chosen[[i]])
    })
    ###access these boxes using input$check_group<i>
    
    # Convert the list to a tagList - this is necessary for the list of items
    # to display properly.
    do.call(tagList, checkbox_output_list)
  })
  
  
    WEATHER_MAP<-reactive({
    if(is.null(WEATHER_STATIONS()) | is.null(input$check_group1)){return(NULL)}
    map=WEATHER_API()[["map"]]
    
    if(is.null(input$weather_file)){
    station_both_data<-WEATHER_STATIONS()[["station_both_data"]]
    geocode_result<-WEATHER_STATIONS()[["geocode_result"]]
    descriptions<-WEATHER_STATIONS()[["descriptions"]]
    ############################################
    ###select best weather station (for now with highest data coverage)###
    chosen<-list()
    for (i in 1:length(station_both_data)){
      inputname <- paste("input$check_group", i, sep="")
      table=eval(parse(text=(inputname)))
      idx<-do.call(match,list(x=table,table=station_both_data[[i]][,1]))
      chosen[[i]]<-station_both_data[[i]][idx,]
    }
    
    #############plot weather station options###########
    map<-list()
    i=1
    for (i in 1:length(station_both_data)){
      center<-c(geocode_result[i][[1]]$results[[1]]$geometry$location$lng,geocode_result[i][[1]]$results[[1]]$geometry$location$lat)
      stations<-data.frame(x=station_both_data[[i]]$longitude,y=station_both_data[[i]]$latitude,type="Avaliable Weather Stations",stringsAsFactors=F)
      stations$type[station_both_data[[i]]$id==chosen[[i]]$id]="Selected Weather Station"
      map[[i]]<-get_googlemap(center,zoom=10)
      map[[i]]<-ggmap(map[[i]])
      map[[i]]<-map[[i]]+geom_point(aes(x=x,y=y,shape=type,colour=type),data=stations,size=5)+theme(legend.position="top")+
        ggtitle(descriptions[i])+scale_colour_manual(values=c("black","red"))
      #print(map[[i]])
      
    }
    }
    return(list(map=map))
  })
  
  output$w_maps <- renderUI({
    if(is.null(WEATHER_MAP())){return(NULL)}
    map<-WEATHER_MAP()[["map"]]
    #tmp_dat<-mod()[["tmp_dat"]]
    
    # Call renderPlot for each one. Plots are only actually generated when they
    # are visible on the web page.
    for (i in 1:length(map)) {
      # Need local so that each item gets its own number. Without it, the value
      # of i in the renderPlot() will be the same across all instances, because
      # of when the expression is evaluated.
      local({
        my_i <- i
        plotname <- paste("w_plot", my_i, sep="")
        output[[plotname]] <- renderPlot({
        print(map[[my_i]])
        })
      })
    }
    
    
    plot_output_list <- lapply(1:length(map), function(i) {
      plotname <- paste("w_plot", i, sep="")
      plotOutput(plotname, height = 800, width = 800)
    })
    
    # Convert the list to a tagList - this is necessary for the list of items
    # to display properly.
    do.call(tagList, plot_output_list)
  })
  
  
  WEATHER_DATA<-reactive({
    if(is.null(WEATHER_STATIONS()) | is.null(input$check_group1)){return(NULL)}
    station_both_data<-WEATHER_STATIONS()[["station_both_data"]]
    geocode_result<-WEATHER_STATIONS()[["geocode_result"]]
    descriptions<-WEATHER_STATIONS()[["descriptions"]]
    
    ALL=WEATHER_API()[["ALL"]]
    
    if(is.null(input$weather_file)){
    
    
    ############################################
    ###select best weather station (for now with highest data coverage)###
    chosen<-list()
    for (i in 1:length(station_both_data)){
      inputname <- paste("input$check_group", i, sep="")
      table=eval(parse(text=(inputname)))
      idx<-do.call(match,list(x=table,table=station_both_data[[i]][,1]))
      chosen[[i]]<-station_both_data[[i]][idx,]
    }
    noaakey=isolate(input$noaa_key)###Mark Albrecht NOAA Key
    DAILY<-data.frame();DAILY_NORMAL<-data.frame()
    for (i in 1:length(chosen)){
      STOP=FALSE
      startdate<-as.Date('2009-01-01')
      enddate<-Sys.Date()
      while (STOP==FALSE){###advance data collection 6 months
        print(startdate)
        next_date<-strsplit(as.character(startdate),"-")
        if(next_date[[1]][2]=="01"){next_date[[1]][2]="07"}else{
          next_date[[1]][2]="01"
          next_date[[1]][1]=as.character(as.numeric(next_date[[1]][1])+1)
        }
        next_date<-as.Date(paste(next_date[[1]],collapse="-"))
        
        if(next_date>=enddate){
          next_date=enddate
          STOP=TRUE
        }
        
        TMP<-ncdc(token=noaakey,datasetid='GHCND', stationid =chosen[[i]]$id, startdate = as.character(startdate),
                  enddate = as.character(next_date),datatypeid=c("TMAX","TMIN","PRCP","SNOW"),limit=1000)
        DAILY<-rbind(DAILY,TMP$data)
        startdate=next_date
      }
      
      TMP<-ncdc(token=noaakey,datasetid='NORMAL_DLY', stationid =chosen[[i]]$id, startdate = '2010-01-01',
                enddate = '2011-01-01',limit=1000,datatypeid='DLY-TAVG-NORMAL')
      DAILY_NORMAL<-rbind(DAILY_NORMAL,TMP$data)
    }

    
    ####construct averages using tapply
    AVG_DATA<-DAILY[DAILY$datatype %in% c("TMIN","TMAX"),]
    id<-as.factor(paste(AVG_DATA$station,AVG_DATA$date,sep="~"))
    AVG<-tapply(AVG_DATA$value,id,mean)
    NAMES<-as.data.frame(strsplit(names(AVG),"~"))
    NAMES<-data.frame(t(NAMES))
    rownames(AVG)<-NULL
    rownames(NAMES)<-NULL
    
    
    ####combine all data into 1 stacked data frame
    AVG<-data.frame(AVG)
    colnames(AVG)<-colnames(DAILY)[2]
    colnames(NAMES)<-colnames(DAILY)[c(1,4)]
    AVG<-data.frame("station"=NAMES[1],"value"=AVG,"datatype"="TAVG","date"=NAMES[2],stringsAsFactors=FALSE)
    AVG$date<-as.character(AVG$date)
    ALL<-rbind(DAILY[,1:4],AVG,DAILY_NORMAL[,1:4])
    ALL$date<-as.Date(ALL$date)
    summary(ALL)
    ###Convert Measurements to Degrees, not Degrees * 10
    idx<-ALL$datatype %in% c("TAVG","TMAX","TMIN","DLY-TAVG-NORMAL")
    ALL$value[idx]<-ALL$value[idx]/10 ###get rid of extra 10 multiplier
    ####Convert Celsius measures to Farenheight
    idx<-ALL$datatype %in% c("TAVG","TMAX","TMIN")
    ALL$value[idx]<-ALL$value[idx]*(9/5)+32###C to F conversion
    
    
    ###construct normals that span the entire data range
    REPLACE_NORMAL<-data.frame()
    for (i in unique(ALL$station)){
      norm_idx<- ALL$datatype=="DLY-TAVG-NORMAL"
      avg_idx<-ALL$datatype=="TAVG"
      station_idx<-ALL$station==i
      NORMAL<-ALL[norm_idx & station_idx,]
      STATION_AVG<-ALL[avg_idx & station_idx,]
      NORMAL_REP<-STATION_AVG
      NORMAL_REP$value=NA
      NORMAL_REP$datatype="DLY-TAVG-NORMAL"
      stripped_date<-format(NORMAL$date,"%m-%d")
      j=1
      for (j in 1:nrow(NORMAL_REP)){
        current_date<-format(NORMAL_REP$date[j],"%m-%d")
        if (current_date=="02-29"){current_date="02-28"}###deal with leap yr
        NORMAL_REP$value[j]<-NORMAL$value[stripped_date %in% current_date]
      }
      
      REPLACE_NORMAL<-rbind(REPLACE_NORMAL,NORMAL_REP)
      
    }
    
    ALL<-ALL[ALL$datatype !="DLY-TAVG-NORMAL",]###drop the 1 year averages
    ALL<-rbind(ALL,REPLACE_NORMAL)###replace the dropped averages
    
    
    ##########compute series that is the difference from the normal for TAVG
    DIFFERENCE_NORMAL<-data.frame()
    for (i in unique(ALL$station)){
      norm_idx<- ALL$datatype=="DLY-TAVG-NORMAL"
      avg_idx<-ALL$datatype=="TAVG"
      station_idx<-ALL$station==i
      NORMAL<-ALL[norm_idx & station_idx,]
      STATION_AVG<-ALL[avg_idx & station_idx,]
      DIFFERENCE<-STATION_AVG
      DIFFERENCE$value=NA
      DIFFERENCE$datatype="DIFF-TAVG-NORMAL"
      for (j in 1:nrow(DIFFERENCE)){
        DIFFERENCE$value[j]=STATION_AVG$value[j]-NORMAL$value[j]
      }
      
      DIFFERENCE_NORMAL<-rbind(DIFFERENCE_NORMAL,DIFFERENCE)
      
    }
    
    ALL<-rbind(ALL,DIFFERENCE_NORMAL)###replace the dropped averages
    }

  return(list(ALL=ALL))
  })
    
  
  output$weather_plot<-renderPlot({
    if(is.null(WEATHER_DATA())){return(NULL)}
    ALL<-WEATHER_DATA()[["ALL"]]
    theGraph <- ggplot(ALL,aes(x=date, y=value)) + 
      geom_point(size = 1) + facet_wrap(~station+datatype, scales = "free") + 
      xlab("Date") + ylab(NULL) + ggtitle("Raw Data")
    print(theGraph)
    
  })

COLLECT_SAVE<-reactive({
  ALL=WEATHER_DATA()[["ALL"]]
  map=WEATHER_MAP()[["map"]]
  station_both_data=WEATHER_STATIONS()[["station_both_data"]]
  geocode_result=WEATHER_STATIONS()[["geocode_result"]]
  descriptions=WEATHER_STATIONS()[["descriptions"]]
  address=WEATHER_STATIONS()[["address"]]
  weather_readtable<-WEATHER_Update()
  
  list(ALL=ALL,map=map,station_both_data=station_both_data,geocode_result=geocode_result,
       descriptions=descriptions,address=address,weather_readtable=weather_readtable)
  
})
  

####add weather save statement for 
output$WEATHER_SAVE<-downloadHandler(
  filename = function(){paste(input$WEATHER_SAVE_NAME,".RData",sep = "")},
  content = function(file){
    saved_weather<-COLLECT_SAVE()
    #saved_api <- reactiveValuesToList(tmp)
    save(saved_weather, file = file)
  })

  
  WEATHER<-reactive({
  if(is.null(WEATHER_DATA())){return(NULL)}
  ALL<-WEATHER_DATA()[["ALL"]]
  CHR<-FINAL()
  ID<-paste(ALL$station,ALL$datatype,sep="_")
  ID<-gsub(":","",ID)###get rid of illegal characters
  ID<-gsub("-","",ID)###get rid of illegal characters
  WEATHER<-list()
  for (i in unique(ID)){
    WEATHER[[i]]<-data.frame(ALL$date[ID==i],ALL$value[ID==i])
    colnames(WEATHER[[i]])<-c("date",i)
  }  
    

  X<-list()
  for (i in names(WEATHER)){
    tmp<-averages(WEATHER[[i]],d_index=1)
    X[[i]]<-tmp$DAY[,-c(1,4)]
  }
  

  START=format(min(CHR$Date),format="%Y-%m-%d")
  END=format(Sys.time(),format="%Y-%m-%d")
  DATA_W<-align_day(X,d_index=rep(1,length(ls(X))),start=START,end=END)
  for (i in 2:length(DATA_W)){
    DATA_W[[i]]<-DATA_W[[i]][-c(1)]
    ###code NA snow and precip events as 0 instead of NA's
    r1<-grep("PRCP",names(DATA_W[[i]]))
    if (length(r1)>0){
      DATA_W[[i]][is.na(DATA_W[[i]][,r1]),r1]<-0
    }
    r1<-grep("SNOW",names(DATA_W[[i]]))
    if (length(r1)>0){
      DATA_W[[i]][is.na(DATA_W[[i]][,r1]),r1]<-0
    }

  }
  
  #DATA_FILL_I<-loess_fill(DATA_I,t_index=1,span=c(10:1/10),folds=5)
  #DATA_FILL_W<-PIECE_fill(DATA_W,t_index=1)
  
  DATA_FILL_W<-list()
  idx<-names(DATA_W)
  DATA_FILL_W[[idx[1]]]<-DATA_W[[idx[1]]]
  for (i in 2:length(DATA_W)){
    DATA_FILL_W[[idx[i]]]<-na.approx(DATA_W[[idx[i]]],na.rm=FALSE)
  }
  
  list(DATA_W=DATA_W,DATA_FILL_W=DATA_FILL_W)
  })
  
  
  ####################################
  #####Weather Insert Ends Here ######
  ####################################

choices<-reactive({
  tmp<-colnames(Data())
  return(tmp)
})

CHR<-reactive({
  CHR<-data.frame(
    Date=Data()[,colnames(Data()) %in% input$date$right],
    Stop_Count=Data()[,colnames(Data()) %in% input$stop$right],
    Total_Cost=Data()[,colnames(Data()) %in% input$cost$right],
    Total_Mileage=Data()[,colnames(Data()) %in% input$mileage$right],
    Destination_Zip=Data()[,colnames(Data()) %in% input$destination$right],
    Origin_Zip=Data()[,colnames(Data()) %in% input$origin$right],
    Orig_State=Data()[,colnames(Data()) %in% input$orig_state$right],
    Delivery_State=Data()[,colnames(Data()) %in% input$delivery_state$right],
    Customer=Data()[,colnames(Data()) %in% input$customer$right],
    Carrier=Data()[,colnames(Data()) %in% input$carrier$right],
    Origin_City=Data()[,colnames(Data()) %in% input$origin_city$right],
    Origin_Sub_Region=Data()[,colnames(Data()) %in% input$orig_sub_region$right],
    Destination_Sub_Region=Data()[,colnames(Data()) %in% input$dest_sub_region$right],
    Origin_Zone=Data()[,colnames(Data()) %in% input$orig_zone$right],
    Destination_Zone=Data()[,colnames(Data()) %in% input$dest_zone$right],
    Destination_City=Data()[,colnames(Data()) %in% input$dest_city$right],
    Origin_Spec_Region=Data()[,colnames(Data()) %in% input$orig_spec_region$right],
    Destination_Spec_Region=Data()[,colnames(Data()) %in% input$dest_spec_region$right],
    Origin_Region=Data()[,colnames(Data()) %in% input$orig_region$right],
    Destination_Region=Data()[,colnames(Data()) %in% input$dest_region$right])
  
  CHR$Date<-as.POSIXlt((CHR$Date-1)*24*60*60,origin="1900-01-01")
  CHR$Date<-format(CHR$Date,format="%m/%d/%Y")
  CHR$Date<-as.Date(CHR$Date,format="%m/%d/%Y")
  CHR$RPM<-CHR$Total_Cost/CHR$Total_Mileage
  CHR$RPM[is.infinite(CHR$RPM)]=NA
  CHR$RPM[CHR$RPM<=0 | CHR$RPM>=10]=NA
  CHR=CHR[!is.na(CHR$RPM),]
  return(CHR)
  
})

FIL<-reactive({
  FIL<-CHR()
  FIL<-FIL[FIL$Date>=input$date_range[1] & FIL$Date<=input$date_range[2],]
  FIL<-FIL[FIL$Total_Cost>=input$cost_lower & FIL$Total_Cost<=input$cost_upper,]
  FIL<-FIL[FIL$Total_Mileage>=input$miles_lower & FIL$Total_Mileage<=input$miles_upper,]
  FIL<-FIL[FIL$RPM>=input$RPM_lower & FIL$RPM<=input$RPM_upper,]
  
  for (i in 1:ncol(FIL)){
    if(class(FIL[[i]]) %in% c("factor")){
      levels(FIL[[i]])[which(levels(FIL[[i]])=="")]="UNKNOWN"
      
    }
    
  }
  
  
  
  
  return(FIL)
  
})

L1RAW<-reactive({
  a=FIL()$Origin_Zip %in% as.numeric(input$l1_orig_zip$right) 
  b=FIL()$Destination_Zip %in% as.numeric(input$l1_dest_zip$right)
  c=FIL()$Orig_State %in% input$l1_orig_state$right
  d=FIL()$Delivery_State %in% input$l1_delivery_state$right
  e=FIL()$Stop_Count %in% as.numeric(input$l1_stop_ct$right)
  f=FIL()$Origin_City %in% input$l1_origin_city$right
  g=FIL()$Origin_Sub_Region %in% input$l1_orig_sub_region$right
  h=FIL()$Destination_Sub_Region %in% input$l1_dest_sub_region$right
  i=FIL()$Origin_Zone %in% input$l1_orig_zone$right
  j=FIL()$Destination_Zone %in% input$l1_dest_zone$right
  k=FIL()$Destination_City %in% input$l1_dest_city$right
  l=FIL()$Origin_Spec_Region %in% input$l1_orig_spec_region$right
  m=FIL()$Destination_Spec_Region %in% input$l1_dest_spec_region$right
  n=FIL()$Origin_Region %in% input$l1_orig_region$right
  o=FIL()$Destination_Region %in% input$l1_dest_region$right
  LANE1<-FIL()[ ((a | c | f | g | i | l | n) & (b | d | h | j | k | m | o)) & e,]
  LANE1$Constructed_Lane<-input$lane1_id 
  LANE1
  
})

L1<-reactive({
  L1<-L1RAW()
  L1<-L1[L1$Date>=input$date_range1[1] & L1$Date<=input$date_range1[2],]
  L1<-L1[L1$Total_Cost>=input$cost_lower1 & L1$Total_Cost<=input$cost_upper1,]
  L1<-L1[L1$Total_Mileage>=input$miles_lower1 & L1$Total_Mileage<=input$miles_upper1,]
  L1<-L1[L1$RPM>=input$RPM_lower1 & L1$RPM<=input$RPM_upper1,]
  
  for (i in 1:ncol(L1)){
    if(class(L1[[i]]) %in% c("factor")){
      levels(L1[[i]])[which(levels(L1[[i]])=="")]="UNKNOWN"
      
    }
    
  }
  
  return(L1)
  
})

#### start the near zero filter

VAR_L1<-reactive({
  data<-L1()
  if(is.null(data)){return(NULL)}
  threshold=input$threshold_L1###number of data points needed to consider removal
  #save(threshold,file="data_pre.RData")###for debugging
  #load("inst/data_pre.RData")###for debugging
  if(input$removal_type_l1=="cust"){data$Use<-data$Customer}
  if(input$removal_type_l1=="carr"){data$Use<-data$Carrier}
  if(input$removal_type_l1=="cust_carr"){data$Use<-paste(data$Customer,data$Carrier)}
  idx<-table(data$Use)
  idx<-as.data.frame(idx)
  idx<-idx[idx$Freq!=0,]
  
  
  data$days=as.numeric(format(data$Date,"%j"))
  data$Date_2<-as.numeric(data$Date)
  adjust_fit<-gam(RPM~s(Date_2,sp=1000)+s(days,bs="cc"),data=data,gamma=1.4)
  data$residuals<-residuals(adjust_fit)
  comp_var<-sd(data$residuals)
  
  idx$l1_bias<-NA###looking for bias turned out to be the best methodology
  idx_e<-1:nrow(idx)
  idx_e<-idx_e[idx$Freq>=threshold]
  for(i in idx_e){
    print(i)
    pull<-data$residuals[data$Use==idx$Var1[i]]
    idx$l1_bias[i]<-abs(sum(pull^2)/length(pull))
  }
  
  
  idx<-idx[order(idx$l1_bias,decreasing = T),]###look for bias where data isn't centered
  list(idx=idx,data=data,comp_var=comp_var,model_fit=adjust_fit,x_vals=data$Date)
})

output$L1_CLEANUP<-renderUI({
  idx<-VAR_L1()[["idx"]]
  choices<-as.character(idx$Var1)
  sel= c()
  if (!is.null(Read_Settings()[["L1_CLEANUP"]])){
    sel <- choices[which(choices%in%Read_Settings()[["L1_CLEANUP"]])]}
  selectizeInput("L1_CLEANUP","Select Data To Remove",choices=choices, selected = sel, multiple=TRUE)
})

output$ratio_cut_L1<-renderUI({###NEW###
  
numericInput("ratio_cut_L1","Select Ratio of Normal to Observed Variance for Removal",value=3,min=1)
})


output$threshold_L1<-renderUI({###NEW###
numericInput("threshold_L1","Select Minimum Number of Data Points To Consider in Series",value=10,min=1,step=1)
})

output$salvage_L1<-renderUI({###NEW###
checkboxInput("salvage_L1","Try To Salvage Partial Data?",value=FALSE)
})

output$remove_selected_l1<-renderUI({###NEW###
checkboxInput("remove_selected_l1","Remove Eliminated Observations from Plot?",value=FALSE)
})

output$removal_type_l1<-renderUI({###NEW###
selectInput("removal_type_l1","Select Type of Removal",c("Customer"="cust","Carrier"="carr","Customer Carrier Combination"="cust_carr"))
})

output$L1_CUSTOMERS<-renderDataTable({
  data<-VAR_L1()[["idx"]]
  data$Percent<-round(data$Freq/sum(data$Freq),2)
  data$Total_Observations<-sum(data$Freq)
  data
  
})


SELECT_L1<-reactive({
  data<-VAR_L1()[["data"]]
  idx<-VAR_L1()[["idx"]]
  comp_var<-VAR_L1()[["comp_var"]]
  model_fit<-VAR_L1()[["model_fit"]]
  x_vals<-VAR_L1()[["x_vals"]]
  choices<-input$L1_CLEANUP
  ratio_cut<-input$ratio_cut_L1###this will let you identify the data to pull
  salvage=input$salvage_L1
  #save(data,idx,comp_var,choices,ratio_cut,salvage,file="data_1.RData")###for debugging
  #load("inst/data_1.RData")###for debugging
  if (is.null(choices)){return(list(data=data,data_remove=NULL,data_preserve=NULL,model_fit=model_fit,x_vals=x_vals))}
  if (!salvage){
    index_data<-data$Use %in% choices
    data_remove<-data[index_data,]
    data<-data[!index_data,]
    return(list(data=data,data_remove=data_remove,data_preserve=NULL,model_fit=model_fit,x_vals=x_vals))
  }
  data_remove<-data.frame()
  data_preserve<-data.frame()
  for (j in 1:length(choices)){
    index_data<-data$Use %in% choices[j]
    tmp<-data[index_data,]
    #plot(RPM~Date,data=tmp)
    fit<-rpart(RPM~Date_2,data=tmp,
               control=rpart.control(xval=10,minbucket=10,cp=0))
    select<-printcp(fit)
    upper_bound=select[,"xerror"]+select[,"xstd"]
    take<-numeric(length(upper_bound))
    take[1]=1
    for(i in 2:length(upper_bound)){
      pp<-min(upper_bound[1:i])-select[1:(i-1),"xerror"]
      take[i]<-all(pp<=0)
    }
    grab<-1:nrow(select)
    grab<-max(grab[take==1])
    cp_min<-select[grab,"CP"]
    tree<-prune(fit,cp=cp_min)
    #   prp(tree,type=4,extra=1,tweak=1.0,branch=1,fallen.leaves=F,
    #       uniform=T,Margin=0,digits=3,varlen=0)
    
    
    levels<-factor(predict(tree))
    levels<-factor(as.numeric(levels))
    levels<-as.numeric(levels)
    for (i in unique(levels)){
      q_dat<-tmp$RPM[levels==i]
      out<-kmeans(q_dat,2)
      levels[levels==i]=out$cluster+max(levels)
    }
    
    levels<-factor(levels)
    levels(levels)<-1:length(levels(levels))
    variance_groups<-numeric(length(levels(levels)))
    for (i in levels(levels)){
      variance_groups[as.numeric(i)]<-sd(tmp$RPM[levels==i])
    }
    
    ratio<-comp_var/variance_groups
    kill<-(ratio>=ratio_cut)
    remove<-levels %in% levels(levels)[kill]
    index_data[index_data==TRUE]<-remove
    data<-data[!index_data,]
    data_remove<-rbind(data_remove,tmp[remove,])
    data_preserve<-rbind(data_preserve,tmp[!remove,])
    #plot(RPM~Date,data=tmp[remove,],col="red",pch=19)
    #points(RPM~Date,data=tmp[!remove,],col="black",pch=19)
  }
  
  
  list(data=data,data_remove=data_remove,data_preserve=data_preserve,model_fit=model_fit,x_vals=x_vals)
  
})


####end the filter stuff here

CLUSTER_PRE_L1<-reactive({
  data<-SELECT_L1()[["data"]]
  data$days=as.numeric(format(data$Date,"%j"))
  data$Date<-as.numeric(data$Date)
  adjust_fit<-gam(RPM~s(Date,sp=1000)+s(days,bs="cc"),data=data)
  data$residuals<-residuals(adjust_fit)
  
  fit<-rpart(residuals~Stop_Count,data=data,
             control=rpart.control(xval=10,minbucket=5,cp=0))
  select<-printcp(fit)
  list(select=select,fit=fit,data=data)
})

output$tree_splits_L1<-renderPlot({
  fit<-CLUSTER_PRE_L1()[["fit"]]
  rsq.rpart(fit)
  
})


output$tree_select_nsplit_L1<-renderUI({
  select<-CLUSTER_PRE_L1()[["select"]]
  choices<-as.numeric(select[,"nsplit"])
  choice<-as.numeric(select[which.min(select[,"xerror"]),"nsplit"])
  if (!is.null(Read_Settings()[["tree_select_nsplit_L1"]])){
    loadchoice <- choices[which(choices%in%Read_Settings()[["tree_select_nsplit_L1"]])]
    if(length(loadchoice) == 1){
      choice <- loadchoice
    }}
  selectInput("tree_select_nsplit_L1", "Choose Number of Tree Splits",
              choices,selected=choice)
  
})

output$tree_adjust_L1<-renderUI({
  checkboxInput("tree_adjust_L1","Adjust Model for Stop Count Based on Tree Effect?",value=TRUE)
})

CLUSTER_L1<-reactive({
  select<-CLUSTER_PRE_L1()[["select"]]
  fit<-CLUSTER_PRE_L1()[["fit"]]
  data<-CLUSTER_PRE_L1()[["data"]]
  cp_min<-select[select[,"nsplit"]==input$tree_select_nsplit_L1,"CP"]
  tree<-prune(fit,cp=cp_min)
  nodes<-as.numeric(row.names(tree$frame))  #node numbers as they appear in frame
  is.leaf<-tree$frame$var =="<leaf>"  #logical vector, indexed on row in frame
  node_leaf<-nodes[is.leaf]  #the leaf node numbers
  rule<-path.rpart(tree,node_leaf)  #extract decision rule for plotting
  tree_result<-tree$frame[is.leaf,]
  tree_result$bin_lower<-min(data$Stop_Count)
  tree_result$bin_upper<-max(data$Stop_Count)
  for (i in 1:length(rule)){
    path<-rule[[i]][-1]
    lower_rule_idx<-grep(">=",path)
    upper_rule_idx<-grep("<",path)
    lower_txt<-path[lower_rule_idx]
    upper_txt<-path[upper_rule_idx]
    
    if(length(lower_txt)>0){
      low_register<-numeric(length(lower_txt))
      for (ii in 1:length(lower_txt)){
        low_register[ii]<-as.numeric(strsplit(lower_txt[ii],">=")[[1]][2])
      }
      low_register<-max(low_register)
      tree_result$bin_lower[i]<-low_register
    }
    
    if(length(upper_txt)>0){
      upper_register<-numeric(length(upper_txt))
      for (ii in 1:length(upper_txt)){
        upper_register[ii]<-as.numeric(strsplit(upper_txt[ii],"<")[[1]][2])
      }
      upper_register<-min(upper_register)
      tree_result$bin_upper[i]<-upper_register
      
    }
    
  }
  
  tree_result$effect<-tree_result$yval-tree_result$yval[tree_result$bin_lower==min(tree_result$bin_lower)]
  idx<-order(tree_result$bin_lower)
  tree_result<-tree_result[idx,]
  t_plot<-tree
  t_plot$frame[,"yval"]<-t_plot$frame[,"yval"]-tree_result$yval[tree_result$bin_lower==min(tree_result$bin_lower)]
  
  
  list(tree=tree,tree_result=tree_result,t_plot=t_plot)
  
})

output$stop_cluster_L1<-renderPlot({
  tree<-CLUSTER_L1()[["t_plot"]]
  prp(tree,type=4,extra=1,tweak=1.0,branch=1,fallen.leaves=F,
      uniform=T,Margin=0,digits=3,varlen=0)
})

output$stop_table_L1<-renderDataTable({
  table<-CLUSTER_L1()[["tree_result"]]
  table
})

L1_adjust<-reactive({
  L1<-SELECT_L1()[["data"]]
  if(input$tree_adjust_L1==TRUE){
    tree<-CLUSTER_L1()[["tree"]]
    effect<-predict(tree,L1)
    L1$RPM<-L1$RPM-effect
  }
  L1  
})



L2RAW<-reactive({
  a=FIL()$Origin_Zip %in% as.numeric(input$l2_orig_zip$right) 
  b=FIL()$Destination_Zip %in% as.numeric(input$l2_dest_zip$right)
  c=FIL()$Orig_State %in% input$l2_orig_state$right
  d=FIL()$Delivery_State %in% input$l2_delivery_state$right
  e=FIL()$Stop_Count %in% as.numeric(input$l2_stop_ct$right)
  f=FIL()$Origin_City %in% input$l2_origin_city$right
  g=FIL()$Origin_Sub_Region %in% input$l2_orig_sub_region$right
  h=FIL()$Destination_Sub_Region %in% input$l2_dest_sub_region$right
  i=FIL()$Origin_Zone %in% input$l2_orig_zone$right
  j=FIL()$Destination_Zone %in% input$l2_dest_zone$right
  k=FIL()$Destination_City %in% input$l2_dest_city$right
  l=FIL()$Origin_Spec_Region %in% input$l2_orig_spec_region$right
  m=FIL()$Destination_Spec_Region %in% input$l2_dest_spec_region$right
  n=FIL()$Origin_Region %in% input$l2_orig_region$right
  o=FIL()$Destination_Region %in% input$l2_dest_region$right
  LANE2<-FIL()[ ((a | c | f | g | i | l | n) & (b | d | h | j | k | m | o)) & e,]
  LANE2$Constructed_Lane<-input$lane2_id 
  LANE2
})
  
L2<-reactive({
  L2<-L2RAW()
  L2<-L2[L2$Date>=input$date_range2[1] & L2$Date<=input$date_range2[2],]
  L2<-L2[L2$Total_Cost>=input$cost_lower2 & L2$Total_Cost<=input$cost_upper2,]
  L2<-L2[L2$Total_Mileage>=input$miles_lower2 & L2$Total_Mileage<=input$miles_upper2,]
  L2<-L2[L2$RPM>=input$RPM_lower2 & L2$RPM<=input$RPM_upper2,]
  
  for (i in 1:ncol(L2)){
    if(class(L2[[i]]) %in% c("factor")){
      levels(L2[[i]])[which(levels(L2[[i]])=="")]="UNKNOWN"
      
    }
    
  }
  
  
  
  
  return(L2)
  
})

#### start the near zero filter

VAR_L2<-reactive({
  data<-L2()
  if(is.null(data)){return(NULL)}
  threshold=input$threshold_L2###number of data points needed to consider removal
  #save(threshold,file="data_pre.RData")###for debugging
  #load("inst/data_pre.RData")###for debugging
  if(input$removal_type_l2=="cust"){data$Use<-data$Customer}
  if(input$removal_type_l2=="carr"){data$Use<-data$Carrier}
  if(input$removal_type_l2=="cust_carr"){data$Use<-paste(data$Customer,data$Carrier)}
  idx<-table(data$Use)
  idx<-as.data.frame(idx)
  idx<-idx[idx$Freq!=0,]
  
  
  data$days=as.numeric(format(data$Date,"%j"))
  data$Date_2<-as.numeric(data$Date)
  adjust_fit<-gam(RPM~s(Date_2,sp=1000)+s(days,bs="cc"),data=data,gamma=1.4)
  data$residuals<-residuals(adjust_fit)
  comp_var<-sd(data$residuals)
  
  idx$l1_bias<-NA###looking for bias turned out to be the best methodology
  idx_e<-1:nrow(idx)
  idx_e<-idx_e[idx$Freq>=threshold]
  for(i in idx_e){
    print(i)
    pull<-data$residuals[data$Use==idx$Var1[i]]
    idx$l1_bias[i]<-abs(sum(pull^2)/length(pull))
  }
  
  
  idx<-idx[order(idx$l1_bias,decreasing = T),]###look for bias where data isn't centered
  list(idx=idx,data=data,comp_var=comp_var,model_fit=adjust_fit,x_vals=data$Date)
})

output$L2_CLEANUP<-renderUI({
  idx<-VAR_L2()[["idx"]]
  choices<-as.character(idx$Var1)
  sel=c()
  if (!is.null(Read_Settings()[["L2_CLEANUP"]])){
    sel <- choices[which(choices%in%Read_Settings()[["L2_CLEANUP"]])]}
  selectizeInput("L2_CLEANUP","Select Data To Remove",choices=choices, selected = sel, multiple=TRUE)
})

output$ratio_cut_L2<-renderUI({###NEW###
  
  numericInput("ratio_cut_L2","Select Ratio of Normal to Observed Variance for Removal",value=3,min=1)
})


output$threshold_L2<-renderUI({###NEW###
  numericInput("threshold_L2","Select Minimum Number of Data Points To Consider in Series",value=10,min=1,step=1)
})

output$salvage_L2<-renderUI({###NEW###
  checkboxInput("salvage_L2","Try To Salvage Partial Data?",value=FALSE)
})

output$remove_selected_l2<-renderUI({###NEW###
  checkboxInput("remove_selected_l2","Remove Eliminated Observations from Plot?",value=FALSE)
})

output$removal_type_l2<-renderUI({###NEW###
  selectInput("removal_type_l2","Select Type of Removal",c("Customer"="cust","Carrier"="carr","Customer Carrier Combination"="cust_carr"))
})

output$L2_CUSTOMERS<-renderDataTable({
  data<-VAR_L2()[["idx"]]
  data$Percent<-round(data$Freq/sum(data$Freq),2)
  data$Total_Observations<-sum(data$Freq)
  data
  
})


SELECT_L2<-reactive({
  data<-VAR_L2()[["data"]]
  idx<-VAR_L2()[["idx"]]
  comp_var<-VAR_L2()[["comp_var"]]
  model_fit<-VAR_L2()[["model_fit"]]
  x_vals<-VAR_L2()[["x_vals"]]
  choices<-input$L2_CLEANUP
  ratio_cut<-input$ratio_cut_L2###this will let you identify the data to pull
  salvage=input$salvage_L2
  #save(data,idx,comp_var,choices,ratio_cut,salvage,file="data_1.RData")###for debugging
  #load("inst/data_1.RData")###for debugging
  if (is.null(choices)){return(list(data=data,data_remove=NULL,data_preserve=NULL,model_fit=model_fit,x_vals=x_vals))}
  if (!salvage){
    index_data<-data$Use %in% choices
    data_remove<-data[index_data,]
    data<-data[!index_data,]
    return(list(data=data,data_remove=data_remove,data_preserve=NULL,model_fit=model_fit,x_vals=x_vals))
  }
  data_remove<-data.frame()
  data_preserve<-data.frame()
  for (j in 1:length(choices)){
    index_data<-data$Use %in% choices[j]
    tmp<-data[index_data,]
    #plot(RPM~Date,data=tmp)
    fit<-rpart(RPM~Date_2,data=tmp,
               control=rpart.control(xval=10,minbucket=10,cp=0))
    select<-printcp(fit)
    upper_bound=select[,"xerror"]+select[,"xstd"]
    take<-numeric(length(upper_bound))
    take[1]=1
    for(i in 2:length(upper_bound)){
      pp<-min(upper_bound[1:i])-select[1:(i-1),"xerror"]
      take[i]<-all(pp<=0)
    }
    grab<-1:nrow(select)
    grab<-max(grab[take==1])
    cp_min<-select[grab,"CP"]
    tree<-prune(fit,cp=cp_min)
    #   prp(tree,type=4,extra=1,tweak=1.0,branch=1,fallen.leaves=F,
    #       uniform=T,Margin=0,digits=3,varlen=0)
    
    
    levels<-factor(predict(tree))
    levels<-factor(as.numeric(levels))
    levels<-as.numeric(levels)
    for (i in unique(levels)){
      q_dat<-tmp$RPM[levels==i]
      out<-kmeans(q_dat,2)
      levels[levels==i]=out$cluster+max(levels)
    }
    
    levels<-factor(levels)
    levels(levels)<-1:length(levels(levels))
    variance_groups<-numeric(length(levels(levels)))
    for (i in levels(levels)){
      variance_groups[as.numeric(i)]<-sd(tmp$RPM[levels==i])
    }
    
    ratio<-comp_var/variance_groups
    kill<-(ratio>=ratio_cut)
    remove<-levels %in% levels(levels)[kill]
    index_data[index_data==TRUE]<-remove
    data<-data[!index_data,]
    data_remove<-rbind(data_remove,tmp[remove,])
    data_preserve<-rbind(data_preserve,tmp[!remove,])
    #plot(RPM~Date,data=tmp[remove,],col="red",pch=19)
    #points(RPM~Date,data=tmp[!remove,],col="black",pch=19)
  }
  
  
  list(data=data,data_remove=data_remove,data_preserve=data_preserve,model_fit=model_fit,x_vals=x_vals)
  
})


####end the filter stuff here

  
  CLUSTER_PRE_L2<-reactive({
    data<-SELECT_L2()[["data"]]
    data$days=as.numeric(format(data$Date,"%j"))
    data$Date<-as.numeric(data$Date)
    adjust_fit<-gam(RPM~s(Date,sp=1000)+s(days,bs="cc"),data=data)
    data$residuals<-residuals(adjust_fit)
    
    fit<-rpart(residuals~Stop_Count,data=data,
               control=rpart.control(xval=10,minbucket=5,cp=0))
    select<-printcp(fit)
    list(select=select,fit=fit,data=data)
  })
  
  output$tree_splits_L2<-renderPlot({
    fit<-CLUSTER_PRE_L2()[["fit"]]
    rsq.rpart(fit)
    
  })
  
  
  output$tree_select_nsplit_L2<-renderUI({
    select<-CLUSTER_PRE_L2()[["select"]]
    choices<-as.numeric(select[,"nsplit"])
    choice<-as.numeric(select[which.min(select[,"xerror"]),"nsplit"])
    if (!is.null(Read_Settings()[["tree_select_nsplit_L2"]])){
      loadchoice <- choices[which(choices%in%Read_Settings()[["tree_select_nsplit_L2"]])]
      if(length(loadchoice) == 1){
        choice <- loadchoice
      }}
    selectInput("tree_select_nsplit_L2", "Choose Number of Tree Splits",
                choices,selected=choice)
    
  })
  
  output$tree_adjust_L2<-renderUI({
    checkboxInput("tree_adjust_L2","Adjust Model for Stop Count Based on Tree Effect?",value=FALSE)
  })
  
  CLUSTER_L2<-reactive({
    select<-CLUSTER_PRE_L2()[["select"]]
    fit<-CLUSTER_PRE_L2()[["fit"]]
    data<-CLUSTER_PRE_L2()[["data"]]
    cp_min<-select[select[,"nsplit"]==input$tree_select_nsplit_L2,"CP"]
    tree<-prune(fit,cp=cp_min)
    nodes<-as.numeric(row.names(tree$frame))  #node numbers as they appear in frame
    is.leaf<-tree$frame$var =="<leaf>"  #logical vector, indexed on row in frame
    node_leaf<-nodes[is.leaf]  #the leaf node numbers
    rule<-path.rpart(tree,node_leaf)  #extract decision rule for plotting
    tree_result<-tree$frame[is.leaf,]
    tree_result$bin_lower<-min(data$Stop_Count)
    tree_result$bin_upper<-max(data$Stop_Count)
    for (i in 1:length(rule)){
      path<-rule[[i]][-1]
      lower_rule_idx<-grep(">=",path)
      upper_rule_idx<-grep("<",path)
      lower_txt<-path[lower_rule_idx]
      upper_txt<-path[upper_rule_idx]
      
      if(length(lower_txt)>0){
        low_register<-numeric(length(lower_txt))
        for (ii in 1:length(lower_txt)){
          low_register[ii]<-as.numeric(strsplit(lower_txt[ii],">=")[[1]][2])
        }
        low_register<-max(low_register)
        tree_result$bin_lower[i]<-low_register
      }
      
      if(length(upper_txt)>0){
        upper_register<-numeric(length(upper_txt))
        for (ii in 1:length(upper_txt)){
          upper_register[ii]<-as.numeric(strsplit(upper_txt[ii],"<")[[1]][2])
        }
        upper_register<-min(upper_register)
        tree_result$bin_upper[i]<-upper_register
        
      }
      
    }
    
    tree_result$effect<-tree_result$yval-tree_result$yval[tree_result$bin_lower==min(tree_result$bin_lower)]
    idx<-order(tree_result$bin_lower)
    tree_result<-tree_result[idx,]
    t_plot<-tree
    t_plot$frame[,"yval"]<-t_plot$frame[,"yval"]-tree_result$yval[tree_result$bin_lower==min(tree_result$bin_lower)]
    
    
    list(tree=tree,tree_result=tree_result,t_plot=t_plot)
    
  })
  
  output$stop_cluster_L2<-renderPlot({
    tree<-CLUSTER_L2()[["t_plot"]]
    prp(tree,type=4,extra=1,tweak=1.0,branch=1,fallen.leaves=F,
        uniform=T,Margin=0,digits=3,varlen=0)
  })
  
  output$stop_table_L2<-renderDataTable({
    table<-CLUSTER_L2()[["tree_result"]]
    table
  })
  
  L2_adjust<-reactive({
    L1<-SELECT_L2()[["data"]]
    if(input$tree_adjust_L2==TRUE){
      tree<-CLUSTER_L2()[["tree"]]
      effect<-predict(tree,L1)
      L1$RPM<-L1$RPM-effect
    }
    L1  
  })
  
  
L3RAW<-reactive({
  a=FIL()$Origin_Zip %in% as.numeric(input$l3_orig_zip$right) 
  b=FIL()$Destination_Zip %in% as.numeric(input$l3_dest_zip$right)
  c=FIL()$Orig_State %in% input$l3_orig_state$right
  d=FIL()$Delivery_State %in% input$l3_delivery_state$right
  e=FIL()$Stop_Count %in% as.numeric(input$l3_stop_ct$right)
  f=FIL()$Origin_City %in% input$l3_origin_city$right
  g=FIL()$Origin_Sub_Region %in% input$l3_orig_sub_region$right
  h=FIL()$Destination_Sub_Region %in% input$l3_dest_sub_region$right
  i=FIL()$Origin_Zone %in% input$l3_orig_zone$right
  j=FIL()$Destination_Zone %in% input$l3_dest_zone$right
  k=FIL()$Destination_City %in% input$l3_dest_city$right
  l=FIL()$Origin_Spec_Region %in% input$l3_orig_spec_region$right
  m=FIL()$Destination_Spec_Region %in% input$l3_dest_spec_region$right
  n=FIL()$Origin_Region %in% input$l3_orig_region$right
  o=FIL()$Destination_Region %in% input$l3_dest_region$right
  LANE3<-FIL()[ ((a | c | f | g | i | l | n) & (b | d | h | j | k | m | o)) & e,]
  LANE3$Constructed_Lane<-input$lane3_id 
  LANE3
})
  

  
L3<-reactive({
  L3<-L3RAW()
  L3<-L3[L3$Date>=input$date_range3[1] & L3$Date<=input$date_range3[2],]
  L3<-L3[L3$Total_Cost>=input$cost_lower3 & L3$Total_Cost<=input$cost_upper3,]
  L3<-L3[L3$Total_Mileage>=input$miles_lower3 & L3$Total_Mileage<=input$miles_upper3,]
  L3<-L3[L3$RPM>=input$RPM_lower3 & L3$RPM<=input$RPM_upper3,]
  
  for (i in 1:ncol(L3)){
    if(class(L3[[i]]) %in% c("factor")){
      levels(L3[[i]])[which(levels(L3[[i]])=="")]="UNKNOWN"
      
    }
    
  }
  
  
  
  
  return(L3)
  
})

#### start the near zero filter

VAR_L3<-reactive({
  data<-L3()
  if(is.null(data)){return(NULL)}
  threshold=input$threshold_L3###number of data points needed to consider removal
  #save(threshold,file="data_pre.RData")###for debugging
  #load("inst/data_pre.RData")###for debugging
  if(input$removal_type_l3=="cust"){data$Use<-data$Customer}
  if(input$removal_type_l3=="carr"){data$Use<-data$Carrier}
  if(input$removal_type_l3=="cust_carr"){data$Use<-paste(data$Customer,data$Carrier)}
  idx<-table(data$Use)
  idx<-as.data.frame(idx)
  idx<-idx[idx$Freq!=0,]
  
  
  data$days=as.numeric(format(data$Date,"%j"))
  data$Date_2<-as.numeric(data$Date)
  adjust_fit<-gam(RPM~s(Date_2,sp=1000)+s(days,bs="cc"),data=data,gamma=1.4)
  data$residuals<-residuals(adjust_fit)
  comp_var<-sd(data$residuals)
  
  idx$l1_bias<-NA###looking for bias turned out to be the best methodology
  idx_e<-1:nrow(idx)
  idx_e<-idx_e[idx$Freq>=threshold]
  for(i in idx_e){
    print(i)
    pull<-data$residuals[data$Use==idx$Var1[i]]
    idx$l1_bias[i]<-abs(sum(pull^2)/length(pull))
  }
  
  
  idx<-idx[order(idx$l1_bias,decreasing = T),]###look for bias where data isn't centered
  list(idx=idx,data=data,comp_var=comp_var,model_fit=adjust_fit,x_vals=data$Date)
})

output$L3_CLEANUP<-renderUI({
  idx<-VAR_L3()[["idx"]]
  choices<-as.character(idx$Var1)
  sel=c()
  if (!is.null(Read_Settings()[["L3_CLEANUP"]])){
    sel <- choices[which(choices%in%Read_Settings()[["L3_CLEANUP"]])]}
  selectizeInput("L3_CLEANUP","Select Data To Remove",choices=choices, selected = sel, multiple=TRUE)
})

output$ratio_cut_L3<-renderUI({###NEW###
  
  numericInput("ratio_cut_L3","Select Ratio of Normal to Observed Variance for Removal",value=3,min=1)
})


output$threshold_L3<-renderUI({###NEW###
  numericInput("threshold_L3","Select Minimum Number of Data Points To Consider in Series",value=10,min=1,step=1)
})

output$salvage_L3<-renderUI({###NEW###
  checkboxInput("salvage_L3","Try To Salvage Partial Data?",value=FALSE)
})

output$remove_selected_l3<-renderUI({###NEW###
  checkboxInput("remove_selected_l3","Remove Eliminated Observations from Plot?",value=FALSE)
})

output$removal_type_l3<-renderUI({###NEW###
  selectInput("removal_type_l3","Select Type of Removal",c("Customer"="cust","Carrier"="carr","Customer Carrier Combination"="cust_carr"))
})

output$L3_CUSTOMERS<-renderDataTable({
  data<-VAR_L3()[["idx"]]
  data$Percent<-round(data$Freq/sum(data$Freq),2)
  data$Total_Observations<-sum(data$Freq)
  data
  
})


SELECT_L3<-reactive({
  data<-VAR_L3()[["data"]]
  idx<-VAR_L3()[["idx"]]
  comp_var<-VAR_L3()[["comp_var"]]
  model_fit<-VAR_L3()[["model_fit"]]
  x_vals<-VAR_L3()[["x_vals"]]
  choices<-input$L3_CLEANUP
  ratio_cut<-input$ratio_cut_L3###this will let you identify the data to pull
  salvage=input$salvage_L3
  #save(data,idx,comp_var,choices,ratio_cut,salvage,file="data_1.RData")###for debugging
  #load("inst/data_1.RData")###for debugging
  if (is.null(choices)){return(list(data=data,data_remove=NULL,data_preserve=NULL,model_fit=model_fit,x_vals=x_vals))}
  if (!salvage){
    index_data<-data$Use %in% choices
    data_remove<-data[index_data,]
    data<-data[!index_data,]
    return(list(data=data,data_remove=data_remove,data_preserve=NULL,model_fit=model_fit,x_vals=x_vals))
  }
  data_remove<-data.frame()
  data_preserve<-data.frame()
  for (j in 1:length(choices)){
    index_data<-data$Use %in% choices[j]
    tmp<-data[index_data,]
    #plot(RPM~Date,data=tmp)
    fit<-rpart(RPM~Date_2,data=tmp,
               control=rpart.control(xval=10,minbucket=10,cp=0))
    select<-printcp(fit)
    upper_bound=select[,"xerror"]+select[,"xstd"]
    take<-numeric(length(upper_bound))
    take[1]=1
    for(i in 2:length(upper_bound)){
      pp<-min(upper_bound[1:i])-select[1:(i-1),"xerror"]
      take[i]<-all(pp<=0)
    }
    grab<-1:nrow(select)
    grab<-max(grab[take==1])
    cp_min<-select[grab,"CP"]
    tree<-prune(fit,cp=cp_min)
    #   prp(tree,type=4,extra=1,tweak=1.0,branch=1,fallen.leaves=F,
    #       uniform=T,Margin=0,digits=3,varlen=0)
    
    
    levels<-factor(predict(tree))
    levels<-factor(as.numeric(levels))
    levels<-as.numeric(levels)
    for (i in unique(levels)){
      q_dat<-tmp$RPM[levels==i]
      out<-kmeans(q_dat,2)
      levels[levels==i]=out$cluster+max(levels)
    }
    
    levels<-factor(levels)
    levels(levels)<-1:length(levels(levels))
    variance_groups<-numeric(length(levels(levels)))
    for (i in levels(levels)){
      variance_groups[as.numeric(i)]<-sd(tmp$RPM[levels==i])
    }
    
    ratio<-comp_var/variance_groups
    kill<-(ratio>=ratio_cut)
    remove<-levels %in% levels(levels)[kill]
    index_data[index_data==TRUE]<-remove
    data<-data[!index_data,]
    data_remove<-rbind(data_remove,tmp[remove,])
    data_preserve<-rbind(data_preserve,tmp[!remove,])
    #plot(RPM~Date,data=tmp[remove,],col="red",pch=19)
    #points(RPM~Date,data=tmp[!remove,],col="black",pch=19)
  }
  
  
  list(data=data,data_remove=data_remove,data_preserve=data_preserve,model_fit=model_fit,x_vals=x_vals)
  
})


####end the filter stuff here


  CLUSTER_PRE_L3<-reactive({
    data<-SELECT_L3()[["data"]]
    data$days=as.numeric(format(data$Date,"%j"))
    data$Date<-as.numeric(data$Date)
    adjust_fit<-gam(RPM~s(Date,sp=1000)+s(days,bs="cc"),data=data)
    data$residuals<-residuals(adjust_fit)
    
    fit<-rpart(residuals~Stop_Count,data=data,
               control=rpart.control(xval=10,minbucket=5,cp=0))
    select<-printcp(fit)
    list(select=select,fit=fit,data=data)
  })
  
  output$tree_splits_L3<-renderPlot({
    fit<-CLUSTER_PRE_L3()[["fit"]]
    rsq.rpart(fit)
    
  })
  
  
  output$tree_select_nsplit_L3<-renderUI({
    select<-CLUSTER_PRE_L3()[["select"]]
    choices<-as.numeric(select[,"nsplit"])
    choice<-as.numeric(select[which.min(select[,"xerror"]),"nsplit"])
    if (!is.null(Read_Settings()[["tree_select_nsplit_L3"]])){
      loadchoice <- choices[which(choices%in%Read_Settings()[["tree_select_nsplit_L3"]])]
      if(length(loadchoice) == 1){
        choice <- loadchoice
      }}
    selectInput("tree_select_nsplit_L3", "Choose Number of Tree Splits",
                choices,selected=choice)
    
  })
  
  output$tree_adjust_L3<-renderUI({
    checkboxInput("tree_adjust_L3","Adjust Model for Stop Count Based on Tree Effect?",value=FALSE)
  })
  
  CLUSTER_L3<-reactive({
    select<-CLUSTER_PRE_L3()[["select"]]
    fit<-CLUSTER_PRE_L3()[["fit"]]
    data<-CLUSTER_PRE_L3()[["data"]]
    cp_min<-select[select[,"nsplit"]==input$tree_select_nsplit_L3,"CP"]
    tree<-prune(fit,cp=cp_min)
    nodes<-as.numeric(row.names(tree$frame))  #node numbers as they appear in frame
    is.leaf<-tree$frame$var =="<leaf>"  #logical vector, indexed on row in frame
    node_leaf<-nodes[is.leaf]  #the leaf node numbers
    rule<-path.rpart(tree,node_leaf)  #extract decision rule for plotting
    tree_result<-tree$frame[is.leaf,]
    tree_result$bin_lower<-min(data$Stop_Count)
    tree_result$bin_upper<-max(data$Stop_Count)
    for (i in 1:length(rule)){
      path<-rule[[i]][-1]
      lower_rule_idx<-grep(">=",path)
      upper_rule_idx<-grep("<",path)
      lower_txt<-path[lower_rule_idx]
      upper_txt<-path[upper_rule_idx]
      
      if(length(lower_txt)>0){
        low_register<-numeric(length(lower_txt))
        for (ii in 1:length(lower_txt)){
          low_register[ii]<-as.numeric(strsplit(lower_txt[ii],">=")[[1]][2])
        }
        low_register<-max(low_register)
        tree_result$bin_lower[i]<-low_register
      }
      
      if(length(upper_txt)>0){
        upper_register<-numeric(length(upper_txt))
        for (ii in 1:length(upper_txt)){
          upper_register[ii]<-as.numeric(strsplit(upper_txt[ii],"<")[[1]][2])
        }
        upper_register<-min(upper_register)
        tree_result$bin_upper[i]<-upper_register
        
      }
      
    }
    
    tree_result$effect<-tree_result$yval-tree_result$yval[tree_result$bin_lower==min(tree_result$bin_lower)]
    idx<-order(tree_result$bin_lower)
    tree_result<-tree_result[idx,]
    t_plot<-tree
    t_plot$frame[,"yval"]<-t_plot$frame[,"yval"]-tree_result$yval[tree_result$bin_lower==min(tree_result$bin_lower)]
    
    
    list(tree=tree,tree_result=tree_result,t_plot=t_plot)
    
  })
  
  output$stop_cluster_L3<-renderPlot({
    tree<-CLUSTER_L3()[["t_plot"]]
    prp(tree,type=4,extra=1,tweak=1.0,branch=1,fallen.leaves=F,
        uniform=T,Margin=0,digits=3,varlen=0)
  })
  
  output$stop_table_L3<-renderDataTable({
    table<-CLUSTER_L3()[["tree_result"]]
    table
  })
  
  L3_adjust<-reactive({
    L1<-SELECT_L3()[["data"]]
    if(input$tree_adjust_L3==TRUE){
      tree<-CLUSTER_L3()[["tree"]]
      effect<-predict(tree,L1)
      L1$RPM<-L1$RPM-effect
    }
    L1  
  })
  
  FINAL<-reactive({
    CHR<-switch(input$lanes_choice,
                "1"={L1_adjust()},
                "2"={rbind(L1_adjust(),L2_adjust())},
                "3"={rbind(L1_adjust(),L2_adjust(),L3_adjust())})

    return(CHR)
    
  })
  
  
  
  LANE_BUNDLE<-reactive({
    CHR<-FINAL()
    DATA_I<-API()[["DATA_I"]]
    DATA_FILL_I<-API()[["DATA_FILL_I"]]
    DATA_W<-WEATHER()[["DATA_W"]]
    DATA_FILL_W<-WEATHER()[["DATA_FILL_W"]]

    X<-list()
    for (i in unique(CHR$Constructed_Lane)){
      tmp<-averages(CHR[CHR$Constructed_Lane==i,c("Date","RPM")],d_index=1)
      X[[i]]<-tmp$DAY[,-c(1)]
    }
    
    

    DATA<-align_day(X,d_index=rep(1,length(ls(X))),start=format(min(CHR$Date),format="%Y-%m-%d"),end=format(Sys.time(),format="%Y-%m-%d"))
    for (i in 2:length(DATA)){
      DATA[[i]]<-DATA[[i]][-c(1)]###remove the date field
      
      ###code NA stop and volume events as 0 instead of NA's
      r1<-grep("Stop",names(DATA[[i]]))
      if (length(r1)>0){
        DATA[[i]][is.na(DATA[[i]][,r1]),r1]<-0
      }
      r1<-grep("volume",names(DATA[[i]]))
      if (length(r1)>0){
        DATA[[i]][is.na(DATA[[i]][,r1]),r1]<-0
      }
      
    }

    DATA_T<-DATA

    if(!is.null(DATA_I)){
    dest=names(DATA_I)
    cc=dest
    for (i in 2:length(dest)){
      cc[i]=colnames(DATA_I[[dest[i]]])
    }
    keep<-cc %in% input$API_choice
    DATA_T<-c(DATA,DATA_I[keep])}
    
    if(!is.null(DATA_W)){###add in weather
      weath<-names(DATA_W)
      DATA_T<-c(DATA_T,DATA_W[weath[-1]])
    }
    
    PLOT<-raw_plot_data(DATA_T,t_index=c(1))
    method="loess"
    if (method=="loess"){
      #DATA_FILL<-loess_fill(DATA,t_index=1,span=c(10:1/10),folds=5)
      #DATA_FILL<-PIECE_fill(DATA,t_index=1)###use piecewise linear to preserve convex hull
      
      DATA_FILL<-list()
      idx<-names(DATA)
      DATA_FILL[[idx[1]]]<-DATA[[idx[1]]]
      for (i in 2:length(DATA)){
        DATA_FILL[[idx[i]]]<-na.approx(DATA[[idx[i]]],na.rm=FALSE)
      }
      
      } else{
        DATA_FILL<-GAM_fill(DATA,t_index=1,gamma=0.5)}
    
    if(!is.null(DATA_FILL_I)){
    DATA_FILL<-c(DATA_FILL,DATA_FILL_I[keep])
    }
    if(!is.null(DATA_FILL_W)){###add in weather
     DATA_FILL<-c(DATA_FILL,DATA_FILL_W[weath[-1]])
    }

    PLOT_FILL<-raw_plot_data(DATA_FILL,t_index=c(1))
    PLOT<-raw_plot_data(DATA_T,t_index=c(1))
    miss_index<-rep("observed",nrow(PLOT))
    miss_index[which(is.na(PLOT$values))]="imputed"
    PLOT_FILL<-data.frame(PLOT_FILL,miss_index)
    TARGET_NAME<- "Nothing for Now"
    tst <- structure(list("DATA_FILL"=DATA_FILL,
                          "PLOT_FILL"=PLOT_FILL,
                          "PLOT"=PLOT,
                          "TARGET_NAME"=TARGET_NAME))
    return(tst)
    
  })
  
  #############################################################################################################################################
  ############################### Starting point for original bundle 3 prep data once and then pass around the program used to be bundle 3
  #################################################################################################################################################
  item <- reactive({
    unlist(input$select)
  })
  
  
  
  
  
  # prep data once and then pass around the program used to be bundle 4
  
  mod1 <- reactive({
    x <-data.frame(LANE_BUNDLE()[['DATA_FILL']])
    date <-x$Align_date
    date_cols<-grep("date",colnames(x))
    x<-x[,-date_cols]
    colnames(x)<-gsub("_data","",colnames(x))
    
    response<-input$response
    max_model_size=input$max_model#number of variables to add
    min_lead=input$min_lead
    max_lead=input$max_lead
    predictors=input$predictors
    interaction_flag=input$interaction
    gamma=input$gamma##tuning parameter in fit
    backcast_ahead=pred_length() ##Prediction length ahead 
    pick=input$pick
    hold_out_data=0#amount of data to hold back for assessing model fit
    fixed=c()#172 is fuel
    lead_lag_store=c(0)###include fixed after a zero
    SEASON=input$seasonality##adjust for seasonality 365 day period (TRUE,FALSE)
    LINEAR=input$linear##adjust for inflation (TRUE,FALSE)
    interaction_split_day=input$interaction_split##cutpoint for interaction
    
    
    ############################################
    ############################################
    #####used to be mod1_source.r
    ############################################
    ############################################
    
    ####model kernel for variable selection and initial future value seeding
    ####This also fits the chosen model
    response<-which(colnames(x) %in% response)
    lead_lag=c(min_lead:max_lead)##reactive, positive is lead
    consider<-c(response,fixed,which(colnames(x) %in% predictors))
    colnames(x)[consider]
    interaction<-rep(FALSE,length(consider))
    interaction[grep("volume",colnames(x)[consider])]=interaction_flag
    
    
    ####remove all values where NA response###
    take_out<-!is.na(apply(x[response],1,mean))
    x<-x[take_out,]
    date<-date[take_out]
    ####Use the carry-forward rule to fill missing values###
    for (s in consider[-1]){
      x[cumsum(!is.na(x[,s]))==0,s]=x[min(which(!is.na(x[,s]))),s]###left hand side
      x[is.na(x[,s]),s]=x[max(which(!is.na(x[,s]))),s]###right hand side
    }
    
    
    
    #year<-as.numeric(format(date,"%Y"))
    #month<-format(date,"%B")
    #reference<-as.Date(strptime(paste(year,"01","01",sep="-"),"%Y-%m-%d"),format="%Y-%m-%d")
    #week<-as.double(floor(difftime(date,reference,units="weeks")))
    #week[which(week==52)]=51 ##cut off last couple of days in year and group with last week
    #week[week<0]=0###deal with some where there are slightly negative numbers that get pushed to -1 with the floor command
    #week<-factor(week)###why is this here???
    
    
    ###cut out future data for backcasting after model fitting###
    
    
    ZZ<-x
    dateZZ<-date
    x<-ZZ[1:(nrow(ZZ)-hold_out_data),]
    date<-dateZZ[1:(nrow(ZZ)-hold_out_data)]
    XX<-x###store data for later use
    datexx<-date
    ################################################
    #######Screening Routine
    ################################################
    
    output<-data.frame(matrix(nrow=max_model_size,ncol=2))
    colnames(output)<-c("Model Terms","Model AIC")
    j=1
    for (j in 1:max_model_size){
      pull<-c(response,fixed)
      consider_tmp<-consider[-which(consider %in% pull)]
      MSEp<-matrix(ncol=3,nrow=length(consider_tmp)*length(lead_lag))
      rownames(MSEp)<-rep("NA",nrow(MSEp))
      colnames(MSEp)<-c("index","AIC","Lead Lag")
      t=1
      i=consider_tmp[1]
      for (i in consider_tmp){
        a=lead_lag[1]
        for (a in lead_lag){
          MSEp[t,1]=i
          MSEp[t,3]=a
          print(paste("model loop=",t," of ",nrow(MSEp)," model size=",j,"lead lag=",a))
          run<-c(response,fixed,i)
          lead_lagg<-c(lead_lag_store,a)
          x<-Lead_lag(XX,run,lead_lagg)
          max_l<-max(lead_lag)
          min_l<-min(lead_lag)
          keep<-rep(TRUE,nrow(x))
          if (max_l>0) {keep[1:max_l]=FALSE}
          if (min_l<0) {keep[(length(keep)+min_l+1):length(keep)]=FALSE}
          x<-x[keep,]
          date<-datexx
          date<-date[keep]
          u=1
          days=as.numeric(format(date,"%j"))
          season<-rep("first_half",length(days))
          season[which(days>=interaction_split_day)]="second_half"
          GAM_DATA<-cbind(days,"date"=as.numeric(date),season,x[run])
          preds<-c()
          for (z in run[-u]){
            if (interaction[which(consider %in% z)]==TRUE){
              preds<-c(preds,paste("s(",colnames(x[z]),",by=season)",sep=""))} else
              {preds<-c(preds,paste("s(",colnames(x[z]),")",sep=""))}
          }
          #preds<-c("s(date,sp=1000)","s(days,bs=\"cc\")",preds)
          if(SEASON==TRUE){preds<-c("s(days,bs=\"cc\")",preds)}
          if(LINEAR==TRUE){preds<-c("s(date,sp=1000)",preds)}
          preds<-paste(preds,collapse="+")
          tmpcmd<-paste("fit=gam(",colnames(x[run[u]]),"~",preds,",data=GAM_DATA,gamma=",gamma,")",sep="")
          eval(parse(text=tmpcmd))
          #y_hat<-predict(fit)
          #MSE<-sum((x[run[u]]-y_hat)^2)/nrow(x)
          MSEp[t,2]<-AIC(fit)
          rownames(MSEp)[t]<-colnames(x)[i]
          t=t+1
        }##close lead lag loop
      }##close variable run loop
      best<-MSEp[which.min(MSEp[,2]),1]
      lagg<-MSEp[which.min(MSEp[,2]),3]
      fixed<-c(fixed,best)
      lead_lag_store=c(lead_lag_store,lagg)
      x<-Lead_lag(XX,c(response,fixed),lead_lag_store)
      names<-colnames(x)
      output[j,2]<-MSEp[which.min(MSEp[,2]),2]
      output[j,1]<-paste(names[c(response,fixed)],collapse=" + ")
      
    }###end major loop%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x<-XX###reset data
    date=datexx###reset date
    print(output)
    pt_data<-MSEp[order(MSEp[,2],decreasing=F),2]
    if(length(pt_data)==1){names(pt_data)=rownames(MSEp)}
    bb<-min(25,length(pt_data))
    pt_data<-pt_data[1:bb]
    pt_data<-pt_data[order(pt_data,decreasing=T)]
    MSEp<-MSEp[order(MSEp[,2],decreasing=F),]
    term_interest=pick
    if (length(nrow(MSEp))!=0){
      pred_index<-MSEp[term_interest,1]
      lead_lag_store[length(lead_lag_store)]<-MSEp[term_interest,3]
    }else{
      pred_index<-MSEp[1]
      lead_lag_store[length(lead_lag_store)]<-MSEp[3]}
    pred_index<-c(fixed[-length(fixed)],pred_index)
    run<-c(response,pred_index)
    interaction<-interaction[which(consider %in% run)]
    consider<-consider[consider %in% run]
    
    ####Select Lead/Lags For X
    x<-Lead_lag(x,run,lead_lag_store)
    keep=!is.na(apply(x[run],1,mean))
    x<-x[keep,]
    date<-date[keep]
    
    
    ##################################
    #####GAM Model
    #####For Multivariate Effect Adjustment
    #################################
    ######Begin Full Gam Fitting#####
    mean_vector<-numeric(length(run))
    error.stream<-data.frame(matrix(nrow=nrow(x),ncol=length(run)))
    days=as.numeric(format(date,"%j"))
    season<-rep("first_half",length(days))
    season[which(days>=interaction_split_day)]="second_half"
    GAM_DATA<-cbind(days,"date"=as.numeric(date),season,x[run])
    u=1
    for (u in 1:length(run)){
      
      preds<-c()
      for (z in run[-u]){
        if (interaction[which(consider %in% z)]==TRUE){
          preds<-c(preds,paste("s(",colnames(x[z]),",by=season)",sep=""))} else
          {preds<-c(preds,paste("s(",colnames(x[z]),")",sep=""))}
      }
      #preds<-c("s(date,sp=1000)","s(days,bs=\"cc\")",preds)
      if(SEASON==TRUE){preds<-c("s(days,bs=\"cc\")",preds)}
      if(LINEAR==TRUE){preds<-c("s(date,sp=1000)",preds)}
      preds<-paste(preds,collapse="+")
      tmpcmd<-paste("fit=gam(",colnames(x[run[u]]),"~",preds,",data=GAM_DATA,gamma=",gamma,")",sep="")
      eval(parse(text=tmpcmd))
      summary(fit)
      error.stream[u]<-residuals(fit)
      colnames(error.stream)[u]<-colnames(x[run[u]])
      if (u==1) fit_1=fit
    }
    
    
    ############################################
    ############################################
    ####Fit the future values for the predictors
    ############################################
    ############################################
    ymin<-min(min(predict(fit_1)),min(x[[response]]))
    ymax<-max(max(predict(fit_1)),max(x[[response]]))
    date_b<-datexx
    
    #####
    #year_ahead<-as.numeric(format(date_b[length(date_b)],"%Y"))
    #reference_ahead<-as.Date(strptime(paste(year_ahead,"01","01",sep="-"),"%Y-%m-%d"),format="%Y-%m-%d")
    #week_ahead<-as.double(floor(difftime(date_b[length(date_b)],reference_ahead,units="weeks")))
    ###make list of future weeks to pick from since dates suck to work with, make it 2X as long as needed then extract elements
    min<-as.POSIXlt(date_b[length(date_b)],origin="1970-01-01")
    #end<-paste(year_ahead+ceiling(backcast_ahead/52)*2,format(date_b[length(date_b)],format="%m-%d"),sep="-")
    #end<-as.Date(end,format="%Y-%m-%d")
    #max<-as.POSIXlt(end,origin="1970-01-01")
    #series<-min+(0:difftime(max,min,units="days"))*24*60*60
    series<-min+(1:backcast_ahead)*24*60*60
    series<-as.Date(series,format="%Y-%m-%d")
    #year<-as.numeric(format(series,format="%Y"))
    #reference<-as.Date(strptime(paste(year,"01","01",sep="-"),"%Y-%m-%d"),format="%Y-%m-%d")
    #week<-as.double(floor(difftime(series,reference,units="weeks")))
    #week[which(week==52)]=51 ##cut off last couple of days in year and group with last week
#     year_week<-paste(year,week,sep="-")
#     year_week<-unique(year_week)
#     concat<-strsplit(year_week,"-")
#     year<-numeric(length(year_week))
#     week<-numeric(length(year_week))
#     reference<-numeric(length(year_week))
#     class(reference)<-"Date"
#     for (s in 1:length(year_week)){
#       year[s]=as.numeric(concat[[s]][1])
#       week[s]=as.numeric(concat[[s]][2])
#       reference[s]=as.Date(strptime(paste(year[s],"01","01",sep="-"),"%Y-%m-%d"),format="%Y-%m-%d")
#     }
#     week_ahead<-week[2:(backcast_ahead+1)]
#     year_ahead<-year[2:(backcast_ahead+1)]
#     reference_ahead<-reference[2:(backcast_ahead+1)]
    #time_ahead<-as.Date(as.POSIXct(reference_ahead,origin="1970-01-01")+week_ahead*7*24*60*60,format="%Y-%m-%d")
time_ahead=series
    
    
    method_pred="Loess" ###set prediciton method between gam and loess
    if (method_pred=="Loess"){
      LM<-linear_detrend(XX[run[-1]],datexx)
      X_linear<-detrend_linear(XX[run[-1]],LM)
      LOESS<-loess_detrend(X_linear,datexx,folds=5,span=1:10/10)
      X_loess<-detrend_loess(X_linear,LOESS)
      Z<-X_loess
      FUTURE<-mean_future(time_ahead,Z,LM,LOESS)} else{
        FUTURE<-mean_future_GAM(time_ahead,datexx,XX[run[-1]],gamma)  
      }
    
    plot_dat<-rbind(XX[run[-1]],FUTURE)
    plot_time<-c(datexx,time_ahead)
    plot_group<-rep("Predicted",length(plot_time))
    plot_group[1:length(datexx)]="Observed"
    plot_group<-rep(plot_group,length(ls(FUTURE)))
    plot_time<-rep(plot_time,length(ls(FUTURE)))
    tmp_dat<-stack(plot_dat)
    tmp_dat<-cbind(tmp_dat,plot_time,plot_group)
    
    
    for (b in 1:ncol(FUTURE)){
      maxx<-max(x[run[b+1]])
      minx<-min(x[run[b+1]])
      FUTURE[which(FUTURE[,b]>=maxx),b]=maxx
      FUTURE[which(FUTURE[,b]<=minx),b]=minx
    }
    pull_future<-FUTURE
    pull_time_ahead<-time_ahead
    
    
    ############################################
    ############################################
    #####used to be mod1_source.r
    ############################################
    ############################################
    
    
    
    tst<-structure(list("pt_data"=pt_data,"response"=response,"interaction"=interaction,"names"=names,"fixed"=fixed,"pull_future"=pull_future,
                        "fit_1"=fit_1,"ymin"=ymin,"ymax"=ymax,"x"=x,"run"=run,"date"=date,"pull_time_ahead"=pull_time_ahead,
                        "tmp_dat"=tmp_dat,"ZZ"=ZZ,"FUTURE"=FUTURE,"XX"=XX,"error.stream"=error.stream,
                        "dateZZ"=dateZZ,"time_ahead"=time_ahead,"lead_lag_store"=lead_lag_store,"consider"=consider,
                        "backcast_ahead"=backcast_ahead,"datexx"=datexx,"gamma"=gamma))
    
  })
  
  
  output$carry_forward <- renderUI({
    XX<-mod1()[['XX']]
    run<-mod1()[['run']]
    choice<-colnames(XX)[run[-1]]
    

    checkboxGroupInput(inputId = "carry_forward",
                       label = "Carry Last Observation Forward?",
                       choices = choice)
  })
  

  
  output$matrix_values <- renderUI({
    matrix_preds<-data.frame("Future Date"=mod1()[['pull_time_ahead']],round(mod1()[['pull_future']],2))
    
    if (!is.null(Read_Settings()[["table_values"]])){
      matrix_preds<-data.frame(Read_Settings()[["table_values"]])
    }
    
    if(!is.null(input$carry_forward)){###put in carry forward values here if selected
      XX<-mod1()[['XX']]
      idx<-input$carry_forward
      NEW<-mod1()[['pull_future']]
      NEW[,idx]<-XX[nrow(XX),idx]
      matrix_preds<-data.frame("Future Date"=mod1()[['pull_time_ahead']],round(NEW,2))
    }
    

      # Initially will be empty

    ###### Code for undoing click values #################
    if(!is.null(predclickval$active)){
      undolength <- max(c(0,input$undopredclick - (length(which(predclickval$active %in% FALSE)))))
      undotargets <- (which(predclickval$active %in% TRUE))
      undolength <- min(c(undolength,length(undotargets)))
      if(undolength > 0){
        predclickval$active[undotargets[(length(undotargets)-undolength+1):length(undotargets)]] = FALSE
      }
    }
    
    if (!is.null(predclickval$graphID)){
      #replacename <- paste0("Future.Values.", predclickval$graphID)
      for (i in 1:length(predclickval$graphID)){
      replacename<-predclickval$graphID[i]
      if((!is.null(matrix_preds[[replacename]])) & predclickval$active[i] == TRUE){
      target<-predclickval$target[i]
      value<-predclickval$value[i]
      matrix_preds[[replacename]][target] <- value
      }
      }
    }


    matrixCustom('table_values', 'Future Values Needed For Prediction',matrix_preds)
    ###you can access these values with input$table_values as the variable anywhere in the server side file

  })
  
TREE_ADJUST<-reactive({
  idx<-c(paste(input$lane1_id,".RPM",sep=""),
         paste(input$lane2_id,".RPM",sep=""),
         paste(input$lane3_id,".RPM",sep=""))
  tree_adj<-c(input$tree_adjust_L1,input$tree_adjust_L2,input$tree_adjust_L3) ###logical of whether to stop count adjust
  id<-which((input$response == idx) & tree_adj) ###this is the response name
  if (length(id)==0){return(NULL)}
  
  tree_result<-switch(id,
               "1"={CLUSTER_L1()[["tree_result"]]},
               "2"={CLUSTER_L2()[["tree_result"]]},
               "3"={CLUSTER_L3()[["tree_result"]]})
  tree<-switch(id,
                      "1"={CLUSTER_L1()[["tree"]]},
                      "2"={CLUSTER_L2()[["tree"]]},
                      "3"={CLUSTER_L3()[["tree"]]})

  
  list(tree_result=tree_result,tree=tree)
})


output$add_stop_ct<-renderUI({
  tree_result<-TREE_ADJUST()[["tree_result"]]
  if(is.null(tree_result)){return(NULL)}
  names<-paste(tree_result$bin_lower,tree_result$bin_upper,sep="-")
  choices<-1:length(names)
  names(choices)<-names
  choice <- NULL
  if (!is.null(Read_Settings()[["add_stop_ct"]])){
    loadchoice <- choices[which(choices%in%Read_Settings()[["add_stop_ct"]])]
    if(length(loadchoice) == 1){
      choice <- loadchoice
    }}
  selectInput("add_stop_ct","Select Stop Count Value for Predictions",choices, selected = choice)
})


output$final_tree<-renderPlot({
    tree<-TREE_ADJUST()[["tree"]]
    if(is.null(tree)){return(NULL)}
    tree_result<-TREE_ADJUST()[["tree_result"]]
    tree$frame[,"yval"]<-tree$frame[,"yval"]-tree_result$yval[as.numeric(input$add_stop_ct)]
    prp(tree,type=4,extra=1,tweak=1.0,branch=1,fallen.leaves=F,
        uniform=T,Margin=0,digits=3,varlen=0)
  })

output$final_stop_table<-renderDataTable({
  table<-TREE_ADJUST()[["tree_result"]]
  if(is.null(table)){return(NULL)}
  table$effect<-table$effect-table$effect[as.numeric(input$add_stop_ct)]
  tableout <- table[,c(2,9,10,11)]
  colnames(tableout) <- c("Number of Observations", "Lower Stop Count Boundary", "Upper Stop Count Boundary", "Effect")
  return(tableout)
})

output$final_tree_message<-renderUI({
  tree<-TREE_ADJUST()[["tree"]]
  if(is.null(tree)){return(h3("Adjustment for Stop Count is Not Turned on (go to lane builder section if desired)"))}
  return(NULL)
})

output$final_stop_table_message<-renderUI({
  table<-TREE_ADJUST()[["tree_result"]]
  if(is.null(table)){return(h3("Adjustment for Stop Count is Not Turned on (go to lane builder section if desired)"))}
  return(NULL)
})

  
  
  mod<-reactive({###had to break here to handle reactive data items for the Future values
    tree_result<-TREE_ADJUST()[["tree_result"]]
    tree_adjust=0
    if(!is.null(tree_result)){tree_adjust<-tree_result$yval[as.numeric(input$add_stop_ct)]}
    TARGET_NAME=LANE_BUNDLE()[['TARGET_NAME']]
    pt_data=mod1()[['pt_data']]
    response=mod1()[['response']]
    names=mod1()[['names']]
    fixed=mod1()[['fixed']]
    pull_future=mod1()[['pull_future']]
    fit_1=mod1()[['fit_1']]
    ymin=mod1()[['ymin']]
    ymax=mod1()[['ymax']]
    x=mod1()[['x']]
    run=mod1()[['run']]
    date=mod1()[['date']]
    pull_time_ahead=mod1()[['pull_time_ahead']]
    tmp_dat=mod1()[['tmp_dat']]
    ZZ=mod1()[['ZZ']]
    ZZ[[response]]<-ZZ[[response]]+tree_adjust
    dateZZ=mod1()[['dateZZ']]
    time_ahead=mod1()[['time_ahead']]
    datexx=mod1()[['datexx']]
    backcast_ahead=mod1()[['backcast_ahead']]
    FUTURE=mod1()[['FUTURE']]
    XX=mod1()[['XX']]
    XX[[response]]<-XX[[response]]+tree_adjust
    error.stream=mod1()[['error.stream']]
    lead_lag_store=mod1()[['lead_lag_store']]
    consider=mod1()[['consider']]
    interaction=mod1()[['interaction']]
    gamma=mod1()[['gamma']]
    table_values=input$table_values
    interaction_split_day=input$interaction_split##cutpoint for interaction
#     CI_pct<-input$CI_percentile
#     CI_Z_score=abs(qnorm((1-CI_pct/100)/2))
    
    LCL_pct <- input$LCL_percentile
    UCL_pct <- input$UCL_percentile
    CI_Z_score_LCL=abs(qnorm((1-LCL_pct/100)/2))
    CI_Z_score_UCL=abs(qnorm((1-UCL_pct/100)/2))
    
    #########################################################################
    ###used to be mod_source.r
    #########################################################################
    ###Performs the future value prediction
    ####use input table
    if (!is.null(table_values)){###don't active first pass (reactive data goes first in shiny)
      if((ncol(table_values)-1)==ncol(FUTURE) & nrow(FUTURE)==nrow(table_values)){
        pf=table_values
        pf<-unclass(pf[,-1])
        class(pf)<-"numeric"
        pf=data.frame(pf)
        colnames(pf)<-colnames(FUTURE)
        FUTURE<-pf}}
    
    
    
    plot_dat<-rbind(XX[run[-1]],FUTURE)
    plot_time<-c(datexx,time_ahead)
    plot_group<-rep("Predicted",length(plot_time))
    plot_group[1:length(datexx)]="Observed"
    plot_group<-rep(plot_group,length(ls(FUTURE)))
    plot_time<-rep(plot_time,length(ls(FUTURE)))
    tmp_dat<-stack(plot_dat)
    tmp_dat<-cbind(tmp_dat,plot_time,plot_group)
    
    
    ###Look at GAM error structure###
    #acf(error.stream,lag.max=52)
    #VARselect(error.stream,lag.max=20,type="const")
    fit<-VAR(error.stream,ic=c("SC"),lag.max=10,type="const")
    summary(fit)
    fit<-restrict(fit,method="ser",thresh=1)
    summary(fit)
    predicted_vals=predict(fit,n.ahead=backcast_ahead)
    
    
    
    mean_delta=predicted_vals$fcst[[1]][,1]
    lcl_delta=predicted_vals$fcst[[1]][,4]
    ucl_delta=predicted_vals$fcst[[1]][,4]
    
    
    plot_dat<-rbind(XX[run[-1]],FUTURE)
    plot_time<-c(datexx,time_ahead)
    FUTURE<-Lead_lag(plot_dat,1:length(plot_dat),lead_lag_store[-1])
    keep=!is.na(apply(FUTURE,1,mean))
    tmp=colnames(FUTURE)
    FUTURE<-data.frame(FUTURE[keep,])
    FUTURE<-data.frame(FUTURE[(nrow(FUTURE)-backcast_ahead+1):nrow(FUTURE),])
    colnames(FUTURE)<-tmp
    time_ahead<-plot_time[keep]
    time_ahead<-time_ahead[(length(time_ahead)-backcast_ahead+1):length(time_ahead)]
    
    
    
    
    days=as.numeric(format(time_ahead,"%j"))
    season<-rep("first_half",length(days))
    season[which(days>=interaction_split_day)]="second_half"
    GAM_DATA<-cbind(days,"date"=as.numeric(time_ahead),season,FUTURE)
    predicted<-predict(fit_1,newdata=GAM_DATA,se.fit=T,pred.var=0)
    predicted_adj<-as.numeric(predicted$fit)+mean_delta+tree_adjust
      

    lcl=predicted_adj-CI_Z_score_LCL*sqrt((lcl_delta/1.96)^2+(as.numeric(predicted$se.fit))^2)
    ucl=predicted_adj+CI_Z_score_UCL*sqrt((ucl_delta/1.96)^2+(as.numeric(predicted$se.fit))^2)
    char<-paste("GAM_Predictions_",ls(x[response]),sep="")
    tmpcmd=paste("GAM_predictions=data.frame(time_ahead,",char,"=predicted_adj,lcl,ucl,FUTURE)",sep="")
    eval(parse(text=tmpcmd))
    GAM_predictions
    #write.csv(GAM_predictions,file=paste(TARGET_NAME,"GAM Predictions.csv"))
    
    ########################add in daily interploation ##########################
    
    smooth_data<-data.frame(date=c(dateZZ,GAM_predictions[[1]]),values=c(ZZ[[response]],GAM_predictions[[2]]),
                            LCL=c(rep(NA,nrow(ZZ)),GAM_predictions[[3]]),UCL=c(rep(NA,nrow(ZZ)),GAM_predictions[[4]]),
                            group=c(rep("observed",length(dateZZ)),rep("predicted",length(GAM_predictions[[1]]))))
#     min<-as.POSIXlt(min(smooth_data[[1]]),origin="1970-01-01")
#     max<-as.POSIXlt(max(smooth_data[[1]]),origin="1970-01-01")+3.5*24*60*60
#     series<-min+(0:difftime(max,min,units="days"))*24*60*60
#     series<-as.Date(series,format="%Y-%m-%d")
#     obs_dates<-as.Date(as.POSIXlt(smooth_data[[1]],origin="1970-01-01")+ c(diff(smooth_data[[1]])/2,3.5)*24*60*60,format="%Y-%m-%d")
#     smooth_values<-numeric(length(series))
#     smooth_values[1:length(smooth_values)]<-NA
#     smooth_values[series %in% obs_dates]<-smooth_data[[2]]
#     smooth_group<-factor(rep(NA,length(series)),levels=levels(smooth_data[[5]]))
#     smooth_group[series %in% obs_dates]<-smooth_data[[5]]
#     smooth_LCL<-numeric(length(series))
#     smooth_LCL[1:length(smooth_LCL)]<-NA
#     smooth_LCL[series %in% obs_dates]<-smooth_data[[3]]
#     smooth_UCL<-numeric(length(series))
#     smooth_UCL[1:length(smooth_UCL)]<-NA
#     smooth_UCL[series %in% obs_dates]<-smooth_data[[4]]
#     smooth_data<-data.frame(date=series,values=smooth_values,LCL=smooth_LCL,UCL=smooth_UCL,group=smooth_group)
#     transition<-floor(mean(c(max(which(smooth_data[[5]]=="observed")),min(which(smooth_data[[5]]=="predicted")))))
#     smooth_data[[5]][1:transition]<-"observed"
#     smooth_data[[5]][(transition+1):nrow(smooth_data)]<-"predicted"
#     input_dat<-list(date=smooth_data[,1],data=smooth_data[,2,drop=F])
#     #ttmmpp<-PIECE_fill(input_dat,t_index=1)
#     #smooth_data[2]<-ttmmpp[[2]]
#     smooth_data[2] <- na.approx(smooth_data[2], na.rm = FALSE)
#     smooth_data[3] <- na.approx(smooth_data[3], na.rm = FALSE)
#     smooth_data[4] <- na.approx(smooth_data[4], na.rm = FALSE)
#     work<-smooth_data[[5]]=="predicted"

# ##Carry first confidence interval difference prediction back to start of prediction dataset
# for (i in 3:4){
#       emptyvals <- which(is.na(smooth_data[[i]][work]))
#       firstfull <- emptyvals[length(emptyvals)] + 1 - length(smooth_data[[2]][work]) + length(work)
#       last_diff <- smooth_data[[i]][firstfull]-smooth_data[[2]][firstfull]
#       smooth_data[[i]][work][emptyvals] <- smooth_data[[2]][work][emptyvals] +last_diff
#       
#     }     
# #     work<-smooth_data[[5]]=="predicted"
# #     band<-smooth_data[[4]][work]-smooth_data[[2]][work]
# #     ttime<-smooth_data[[1]][work]
# #     non_empty<-which(!is.na(band))
# # #     for (g in 2:length(non_empty)){###piecewise linear fit
# # #       ff<-(non_empty[g-1]+1):(non_empty[g]-1)
# # #       dat<-data.frame(y=band[non_empty[(g-1):g]],x=ttime[non_empty[(g-1):g]])
# # #       qf<-lm(y~x,data=dat)
# # #       band[ff]<-predict(qf,newdata=data.frame(x=ttime[ff]))
# # #     }
# #     band <- na.approx(band, na.rm = FALSE)
# #     band[1:(non_empty[1]-1)]<-band[non_empty[1]]
# #     smooth_data[[3]][work]<-smooth_data[[2]][work]-band
# #     smooth_data[[4]][work]<-smooth_data[[2]][work]+band
#     
#     ###set CI limits in names
    colnames(smooth_data)[3:4]<-c(paste0("LCL_",LCL_pct),paste0("UCL_",UCL_pct))
    
    
    ##########################################################################
    
    
    
    Conditional_effects<-data.frame("Intercept"=attr(predict(fit_1,type="terms",newdata=GAM_DATA),"constant"),predict(fit_1,type="terms",newdata=GAM_DATA),"Autoregressive_error"=mean_delta)
    Conditional_effects<-data.frame(Conditional_effects,"Sum of Effects"=apply(Conditional_effects,1,sum))
    Conditional_effects<-data.frame("Date"=time_ahead,Conditional_effects)
    Conditional_effects<-data.frame(Conditional_effects,"Stop Count Effect"=tree_adjust)
    #Conditional_effects
    #write.csv(Conditional_effects,file=paste(TARGET_NAME,"GAM Effects.csv"))
    
    #########################################################################
    ###used to be mod_source.r
    #########################################################################
    
    
    
    #save(backcast_ahead,run,lead_lag_store,ZZ,dateZZ,TARGET_NAME,consider,interaction,gamma,response,file="Bundle_3.RData")
    tst<-structure(list("pt_data"=pt_data,"response"=response,"names"=names,"fixed"=fixed,"pull_future"=pull_future,
                        "fit_1"=fit_1,"ymin"=ymin,"ymax"=ymax,"x"=x,"run"=run,"date"=date,"pull_time_ahead"=pull_time_ahead,
                        "tmp_dat"=tmp_dat,"predicted_vals"=predicted_vals,"ZZ"=ZZ,
                        "dateZZ"=dateZZ,"time_ahead"=time_ahead,"GAM_predictions"=GAM_predictions,
                        "backcast_ahead"=backcast_ahead,"datexx"=datexx,"Conditional_effects"=Conditional_effects,
                        "lead_lag_store"=lead_lag_store,"TARGET_NAME"=TARGET_NAME,"consider"=consider,"interaction"=interaction,
                        "gamma"=gamma,"smooth_data"=smooth_data))
    
  }) 



  
  vol_integrator<-reactive({
    TARGET_NAME=LANE_BUNDLE()[['TARGET_NAME']]
    pt_data=mod1()[['pt_data']]
    response=mod1()[['response']]
    names=mod1()[['names']]
    fixed=mod1()[['fixed']]
    pull_future=mod1()[['pull_future']]
    fit_1=mod1()[['fit_1']]
    ymin=mod1()[['ymin']]
    ymax=mod1()[['ymax']]
    x=mod1()[['x']]
    run=mod1()[['run']]
    date=mod1()[['date']]
    pull_time_ahead=mod1()[['pull_time_ahead']]
    tmp_dat=mod1()[['tmp_dat']]
    ZZ=mod1()[['ZZ']]
    dateZZ=mod1()[['dateZZ']]
    time_ahead=mod1()[['time_ahead']]
    datexx=mod1()[['datexx']]
    backcast_ahead=mod1()[['backcast_ahead']]
    FUTURE=mod1()[['FUTURE']]
    XX=mod1()[['XX']]
    error.stream=mod1()[['error.stream']]
    lead_lag_store=mod1()[['lead_lag_store']]
    consider=mod1()[['consider']]
    interaction=mod1()[['interaction']]
    gamma=mod1()[['gamma']]

    ############### Resume work here ##############################
    
#     LCL_pct <- input$LCL_percentile
#     UCL_pct <- input$UCL_percentile
#     CI_Z_score_LCL=abs(qnorm((1-LCL_pct/100)/2))
#     CI_Z_score_UCL=abs(qnorm((1-UCL_pct/100)/2))
    
    ####identify volume lane
    vol_idx<-which(colnames(x) %in% input$volume)
    
    
    ####predict future lane volume
    method_pred="Loess" ###set prediciton method between gam and loess
    if (method_pred=="Loess"){
      LM<-linear_detrend(XX[vol_idx],datexx)
      X_linear<-detrend_linear(XX[vol_idx],LM)
      LOESS<-loess_detrend(X_linear,datexx,folds=5,span=1:10/10)
      X_loess<-detrend_loess(X_linear,LOESS)
      Z<-X_loess
      FUTURE<-mean_future(time_ahead,Z,LM,LOESS)} else{
        FUTURE<-mean_future_GAM(time_ahead,datexx,XX[vol_idx],gamma)  
      }
    
    plot_dat<-rbind(XX[vol_idx],FUTURE)
    plot_time<-c(datexx,time_ahead)
    plot_group<-rep("Predicted",length(plot_time))
    plot_group[1:length(datexx)]="Observed"
    plot_group<-rep(plot_group,length(ls(FUTURE)))
    plot_time<-rep(plot_time,length(ls(FUTURE)))
    tmp_dat<-stack(plot_dat)
    tmp_dat<-cbind(tmp_dat,plot_time,plot_group)
    
    
    for (b in 1:ncol(FUTURE)){
      maxx<-max(x[vol_idx])
      minx<-min(x[vol_idx])
      FUTURE[which(FUTURE[,b]>=maxx),b]=maxx
      FUTURE[which(FUTURE[,b]<=minx),b]=minx
    }
    pull_future<-FUTURE
    pull_time_ahead<-time_ahead
    

    #####daily smoothing of lane volume####
    smooth_data<-data.frame(date=c(dateZZ,pull_time_ahead),values=c(ZZ[[vol_idx]],FUTURE[[1]]),
                            group=c(rep("observed",length(dateZZ)),rep("predicted",length(FUTURE[[1]]))))
#     min<-as.POSIXlt(min(smooth_data[[1]]),origin="1970-01-01")
#     max<-as.POSIXlt(max(smooth_data[[1]]),origin="1970-01-01")+3.5*24*60*60
#     series<-min+(0:difftime(max,min,units="days"))*24*60*60
#     series<-as.Date(series,format="%Y-%m-%d")
#     obs_dates<-as.Date(as.POSIXlt(smooth_data[[1]],origin="1970-01-01")+ c(diff(smooth_data[[1]])/2,3.5)*24*60*60,format="%Y-%m-%d")
#     smooth_values<-numeric(length(series))
#     smooth_values[1:length(smooth_values)]<-NA
#     smooth_values[series %in% obs_dates]<-smooth_data[[2]]
#     smooth_group<-factor(rep(NA,length(series)),levels=levels(smooth_data[[3]]))
#     smooth_group[series %in% obs_dates]<-smooth_data[[3]]
#     smooth_data<-data.frame(date=series,values=smooth_values,group=smooth_group)
#     transition<-floor(mean(c(max(which(smooth_data[[3]]=="observed")),min(which(smooth_data[[3]]=="predicted")))))
#     smooth_data[[3]][1:transition]<-"observed"
#     smooth_data[[3]][(transition+1):nrow(smooth_data)]<-"predicted"
# #     input_dat<-list(date=smooth_data[,1],data=smooth_data[,2,drop=F])
# #     ttmmpp<-PIECE_fill(input_dat,t_index=1)
#     smooth_data[2]<-na.approx(smooth_data[2], na.rm = FALSE)
    
    return(smooth_data)
    
  })  



  # prep data once and then pass around the program bundle 5 drop in
  
  mod2 <- reactive({
    backcast_ahead=mod()[['backcast_ahead']]
    run=mod()[['run']]
    lead_lag_store=mod()[['lead_lag_store']]
    ZZ=mod()[['ZZ']]
    dateZZ=mod()[['dateZZ']]
    TARGET_NAME=mod()[["TARGET_NAME"]]
    consider=mod()[["consider"]]
    interaction=mod()[["interaction"]]
    gamma=mod()[["gamma"]]
    response=mod()[["response"]]
    SEASON=input$seasonality##adjust for seasonality 365 day period (TRUE,FALSE)
    LINEAR=input$linear##adjust for inflation (TRUE,FALSE)
    interaction_split_day=input$interaction_split##cutpoint for interaction
    
    backcast_length=input$backcast_length-1#length of backcast interval
    
    ##############################################
    ######used to be mod_bcst_source.r
    #############################################
    
    
    
    print(run)#check model vars
    print(lead_lag_store)#lead lag for model vars
    output_backcast<-data.frame()#initialize the output vector
    
    
    
    m=backcast_length
    for (m in backcast_length:0){
      x<-ZZ[1:(nrow(ZZ)-m-backcast_ahead),]
      date<-dateZZ[1:(nrow(ZZ)-m-backcast_ahead)]
      XX<-x
      datexx<-date
      
      
      ####Select Lead/Lags For X
      x<-Lead_lag(x,run,lead_lag_store)
      keep=!is.na(apply(x[run],1,mean))
      x<-x[keep,]
      date<-date[keep]
      ##################################
      #####GAM Model
      #####For Multivariate Effect Adjustment
      #################################
      ######Begin Full Gam Fitting#####
      mean_vector<-numeric(length(run))
      error.stream<-data.frame(matrix(nrow=nrow(x),ncol=length(run)))
      days=as.numeric(format(date,"%j"))
      season<-rep("first_half",length(days))
      season[which(days>=interaction_split_day)]="second_half"
      GAM_DATA<-cbind(days,"date"=as.numeric(date),season,x[run])
      u=1
      for (u in 1:length(run)){
        
        preds<-c()
        for (z in run[-u]){
          if (interaction[which(consider %in% z)]==TRUE){
            preds<-c(preds,paste("s(",colnames(x[z]),",by=season)",sep=""))} else
            {preds<-c(preds,paste("s(",colnames(x[z]),")",sep=""))}
        }
        #preds<-c("s(date,sp=1000)","s(days,bs=\"cc\")",preds)
        if(SEASON==TRUE){preds<-c("s(days,bs=\"cc\")",preds)}
        if(LINEAR==TRUE){preds<-c("s(date,sp=1000)",preds)}
        preds<-paste(preds,collapse="+")
        tmpcmd<-paste("fit=gam(",colnames(x[run[u]]),"~",preds,",data=GAM_DATA,gamma=",gamma,")",sep="")
        eval(parse(text=tmpcmd))
        summary(fit)
        error.stream[u]<-residuals(fit)
        colnames(error.stream)[u]<-colnames(x[run[u]])
        if (u==1) fit_1=fit
      }
      
      
      
      #####Asssess Multivariate GAM fits######
      #####Perform Mean function Predictions####
      #par(op)
      ymin<-min(min(predict(fit_1)),min(x[[response]]))
      ymax<-max(max(predict(fit_1)),max(x[[response]]))
      date_b<-datexx
      
      
      #####
      #year_ahead<-as.numeric(format(date_b[length(date_b)],"%Y"))
      #reference_ahead<-as.Date(strptime(paste(year_ahead,"01","01",sep="-"),"%Y-%m-%d"),format="%Y-%m-%d")
      #week_ahead<-as.double(floor(difftime(date_b[length(date_b)],reference_ahead,units="weeks")))
      ###make list of future weeks to pick from since dates suck to work with, make it 2X as long as needed then extract elements
      min<-as.POSIXlt(date_b[length(date_b)],origin="1970-01-01")
      #end<-paste(year_ahead+ceiling(backcast_ahead/52)*2,format(date_b[length(date_b)],format="%m-%d"),sep="-")
      #end<-as.Date(end,format="%Y-%m-%d")
      #max<-as.POSIXlt(end,origin="1970-01-01")
      #series<-min+(0:difftime(max,min,units="days"))*24*60*60
      series<-min+(1:backcast_ahead)*24*60*60
      series<-as.Date(series,format="%Y-%m-%d")
      #year<-as.numeric(format(series,format="%Y"))
      #reference<-as.Date(strptime(paste(year,"01","01",sep="-"),"%Y-%m-%d"),format="%Y-%m-%d")
      #week<-as.double(floor(difftime(series,reference,units="weeks")))
      #week[which(week==52)]=51 ##cut off last couple of days in year and group with last week
      #     year_week<-paste(year,week,sep="-")
      #     year_week<-unique(year_week)
      #     concat<-strsplit(year_week,"-")
      #     year<-numeric(length(year_week))
      #     week<-numeric(length(year_week))
      #     reference<-numeric(length(year_week))
      #     class(reference)<-"Date"
      #     for (s in 1:length(year_week)){
      #       year[s]=as.numeric(concat[[s]][1])
      #       week[s]=as.numeric(concat[[s]][2])
      #       reference[s]=as.Date(strptime(paste(year[s],"01","01",sep="-"),"%Y-%m-%d"),format="%Y-%m-%d")
      #     }
      #     week_ahead<-week[2:(backcast_ahead+1)]
      #     year_ahead<-year[2:(backcast_ahead+1)]
      #     reference_ahead<-reference[2:(backcast_ahead+1)]
      #time_ahead<-as.Date(as.POSIXct(reference_ahead,origin="1970-01-01")+week_ahead*7*24*60*60,format="%Y-%m-%d")
      time_ahead=series
      
      y=colnames(XX[run[-1]])
      FUTURE<-data.frame(matrix(nrow=length(time_ahead),ncol=length(y)))
      colnames(FUTURE)<-y
      plot_dat<-rbind(XX[run[-1]],FUTURE)
      plot_time<-c(datexx,time_ahead)
      plot_group<-rep("Predicted",length(plot_time))
      plot_group[1:length(datexx)]="Observed"
      plot_group<-rep(plot_group,length(ls(FUTURE)))
      plot_time<-rep(plot_time,length(ls(FUTURE)))
      tmp_dat<-stack(plot_dat)
      tmp_dat<-cbind(tmp_dat,plot_time,plot_group)
      
      
      
      
      ###Construct True Future during backcasting routine
      zz<-Lead_lag(ZZ,run,lead_lag_store)
      keep=!is.na(apply(zz[run],1,mean))
      zz<-zz[keep,]
      tmp<-data.frame(zz[(nrow(XX)+1):(nrow(XX)+backcast_ahead),run[-1]])
      not_null<-!is.na(apply(tmp,1,mean))
      FUTURE[which(not_null),1:ncol(FUTURE)]<-tmp[which(not_null),]
      
      
      plot_dat<-rbind(XX[run[-1]],FUTURE)
      plot_time<-c(datexx,time_ahead)
      plot_group<-rep("Predicted",length(plot_time))
      plot_group[1:length(datexx)]="Observed"
      plot_group<-rep(plot_group,length(ls(FUTURE)))
      plot_time<-rep(plot_time,length(ls(FUTURE)))
      tmp_dat<-stack(plot_dat)
      tmp_dat<-cbind(tmp_dat,plot_time,plot_group)
      
      
      ###Look at GAM error structure###
      fit<-VAR(error.stream,ic=c("SC"),lag.max=10,type="const")
      fit<-restrict(fit,method="ser",thresh=0.02)
      predicted_vals=predict(fit,n.ahead=backcast_ahead)
      
      
      mean_delta=predicted_vals$fcst[[1]][,1]
      lcl_delta=predicted_vals$fcst[[1]][,4]
      ucl_delta=predicted_vals$fcst[[1]][,4]
      
      
      plot_dat<-rbind(XX[run[-1]],FUTURE)
      plot_time<-c(datexx,time_ahead)
      FUTURE<-Lead_lag(plot_dat,1:length(plot_dat),lead_lag_store[-1])
      keep=!is.na(apply(FUTURE,1,mean))
      tmp=colnames(FUTURE)
      FUTURE<-data.frame(FUTURE[keep,])
      FUTURE<-data.frame(FUTURE[(nrow(FUTURE)-backcast_ahead+1):nrow(FUTURE),])
      colnames(FUTURE)<-tmp
      time_ahead<-plot_time[keep]
      time_ahead<-time_ahead[(length(time_ahead)-backcast_ahead+1):length(time_ahead)]
      
      
      
      
      days=as.numeric(format(time_ahead,"%j"))
      season<-rep("first_half",length(days))
      season[which(days>=interaction_split_day)]="second_half"
      GAM_DATA<-cbind(days,"date"=as.numeric(time_ahead),season,FUTURE)
      predicted<-predict(fit_1,newdata=GAM_DATA,se.fit=T,pred.var=0)
      predicted_adj<-as.numeric(predicted$fit)+mean_delta
      lcl=predicted_adj-1.96*sqrt((lcl_delta/1.96)^2+(as.numeric(predicted$se.fit))^2)
      ucl=predicted_adj+1.96*sqrt((lcl_delta/1.96)^2+(as.numeric(predicted$se.fit))^2)
      char<-paste("GAM_Predictions_",ls(x[response]),sep="")
      tmpcmd=paste("GAM_predictions=data.frame(time_ahead,",char,"=predicted_adj,lcl,ucl,FUTURE)",sep="")
      eval(parse(text=tmpcmd))
      output_backcast<-rbind(output_backcast,GAM_predictions[nrow(GAM_predictions),])
    }
    obs<-ZZ[which(dateZZ %in% output_backcast[[1]]),response]
    pred<-output_backcast[2]
    percent_error<-abs((obs-pred)/obs)
    
    R<-cor(obs,pred)^2
    percent_error<-mean(percent_error[[1]])
    
    
    
    ################Linear interpolation of daily values ########################################
    
    smooth_data<-output_backcast
#     min<-as.POSIXlt(min(smooth_data[[1]]),origin="1970-01-01")
#     max<-as.POSIXlt(max(smooth_data[[1]]),origin="1970-01-01")+3.5*24*60*60
#     series<-min+(0:difftime(max,min,units="days"))*24*60*60
#     series<-as.Date(series,format="%Y-%m-%d")
#     obs_dates<-as.Date(as.POSIXlt(smooth_data[[1]],origin="1970-01-01")+ c(diff(smooth_data[[1]])/2,3.5)*24*60*60,format="%Y-%m-%d")
#     smooth_values<-numeric(length(series))
#     smooth_values[1:length(smooth_values)]<-NA
#     smooth_values[series %in% obs_dates]<-smooth_data[[2]]
#     smooth_data <- data.frame(date=series,matrix(nrow=length(series),ncol=ncol(output_backcast)-1))
#     colnames(smooth_data) <- colnames(output_backcast)
#     smooth_data[series %in%obs_dates,2:ncol(smooth_data)] <- output_backcast[,2:ncol(smooth_data)]
#     smooth_data[,2:ncol(smooth_data)] <- na.approx(smooth_data[,2:ncol(smooth_data)], na.rm = FALSE)
    backcast_daily <- smooth_data
    
    #write.csv(output_backcast,file=paste(TARGET_NAME,backcast_ahead," Weeks_Ahead_Backcasting.csv")) 
    ########end backcasting source
    
    
    ##############################################
    ######used to be mod_bcst_source.r#####
    #############################################
    
    
    
    tst<-structure(list("output_backcast"=output_backcast,
                        "percent_error"=percent_error,"R"=R,"backcast_daily"=backcast_daily))
    
  })
  


  ########################################################
  ################ New outputs from bundle 1####
  ############################################################

output$raw_api <- renderUI({
  #if (input$refresh==0 & is.null(input$api_file)){return(NULL)}
  api_readtable <- API_Update()
  api_readtable<-data.frame(rbind(toupper(colnames(api_readtable)),as.matrix(api_readtable)))
  if (!is.null(Read_Settings()[["api_names"]])){
  api_readtable<-data.frame(Read_Settings()[["api_names"]])
  }
    
  matrixCustom('api_names', 'API Indicators to Read',api_readtable)
  ###you can access these values with input$api_names as the variable anywhere in the server side file
  
})


  output$raw_data <- renderDataTable({
    Data()
    
  })
  
  
  output$raw_indicators <- renderDataTable({
    if(is.null(API())){return(NULL)}
    DATA_I<-API()[["DATA_I"]]
    dest=names(DATA_I)
    cc=dest
    for (i in 2:length(dest)){
      cc[i]=colnames(DATA_I[[dest[i]]])
    }
    keep<-cc %in% input$API_choice
    data.frame(Abbreviations=dest[keep],Full_Names=cc[keep])
    
  })
  
  output$raw_indicators_2 <- renderDataTable({
    if(is.null(API())){return(NULL)}
    DATA_I<-API()[["DATA_I"]]
    dest=names(DATA_I)
    cc=dest
    for (i in 2:length(dest)){
      cc[i]=colnames(DATA_I[[dest[i]]])
    }
    keep<-cc %in% input$API_choice
    data.frame(Abbreviations=dest[keep],Full_Names=cc[keep])
    
  })
  
  output$raw_indicators_3 <- renderDataTable({
    if(is.null(API())){return(NULL)}
    DATA_I<-API()[["DATA_I"]]
    dest=names(DATA_I)
    cc=dest
    for (i in 2:length(dest)){
      cc[i]=colnames(DATA_I[[dest[i]]])
    }
    keep<-cc %in% input$API_choice
    data.frame(Abbreviations=dest[keep],Full_Names=cc[keep])
    
  })
  
  output$selected_data <- renderDataTable({
    CHR()##if you don't use clean dates (above), this will crash...
    
  })
  
  output$outlier_rpm<-renderDataTable({
    FIL()
    
  })
  
  output$outlier_rpm_plot<-renderPlot({
    if(!is.null(FIL())){
      dat=FIL()
      sp<-ggplot(dat,aes(x=Date,y=RPM))+geom_point(alpha=0.1,size=1)+
        ggtitle("RPM by Date after Filtering")
      print(sp)} else{
        return(NULL)}
    
  })
#browser()
  output$l1_raw_plot<-renderPlot({
    if(!is.null(L1RAW())){
      dat=L1RAW()
      sp<-ggplot(dat,aes(x=Date,y=RPM))+geom_point(alpha=0.1,size=1)+
        ggtitle("Raw Data Selected for Lane")
      print(sp)} else{
        return(NULL)}
    
  })

output$stop_table1 <- renderUI({
  datset <- L1RAW()
  stopnames <- c("Lower Stop Count", "Upper Stop Count", "Avg RPM", "Avg Mileage")
  startvals <- c(min(datset[["Stop_Count"]]),max(datset[["Stop_Count"]]),1,1)
  stop_table<-data.frame(rbind(toupper(stopnames),startvals))
  if (!is.null(Read_Settings()[["stop_table1"]])){
    stop_table<-data.frame(Read_Settings()[["stop_table1"]])
  }
  
  if((!is.null(input$stop_table1)) && (nrow(input$stop_table1) >= 2)){
    valmatrix <- matrix(data = NA, nrow = nrow(input$stop_table1) - 1, ncol = 4)
    for (i in 2:nrow(input$stop_table1)){
      if(!(is.na(as.numeric(input$stop_table1[i,1])) | is.na(as.numeric(input$stop_table1[i,2])))){
        valmatrix[i-1,1] <- max(as.numeric(input$stop_table1[i,1]), startvals[1])
        valmatrix[i-1,2] <- min(as.numeric(input$stop_table1[i,2]), startvals[2])
        avgsub <- which(datset[["Stop_Count"]] %in% c(valmatrix[i-1,1]:valmatrix[i-1,2]))
        valmatrix[i-1,3] <- round(mean(datset[["RPM"]][avgsub]), digits = 3)
        valmatrix[i-1,4] <- round(mean(datset[["Total_Mileage"]][avgsub]), digits = 1)
      }
    }
    stop_table<-data.frame(rbind(toupper(stopnames),valmatrix))
  }
  
  matrixCustom('stop_table1', 'Rate and Mileage Between Stop Counts',stop_table)
  ###you can access these values with input$stop_table1 as the variable anywhere in the server side file
  
})



output$outlier_rpm_plot1<-renderPlot({
  if(!is.null(SELECT_L1())){
    dat=SELECT_L1()[["data"]]
    model_fit=SELECT_L1()[["model_fit"]]
    x_vals=SELECT_L1()[["x_vals"]]
    remove=SELECT_L1()[["data_remove"]]
    if (empty(remove)){remove=NULL}
    preserve=SELECT_L1()[["data_preserve"]]
    if(empty(preserve)){preserve=NULL}
    dat$series="NonSelected"
    sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)

    
    if(!is.null(remove) & is.null(preserve) & !input$remove_selected_l1){
      remove$series="Removed"
      dat<-rbind(dat,remove)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)

    }
    if(!is.null(preserve) & is.null(remove) & !input$remove_selected_l1){
      preserve$series="Kept"
      dat<-rbind(dat,preserve)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    if(!is.null(preserve) & !is.null(remove) & !input$remove_selected_l1){
      remove$series="Removed"
      preserve$series="Kept"
      dat<-rbind(dat,remove,preserve)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    
    if(!is.null(remove) & is.null(preserve) & input$remove_selected_l1){
      dat<-rbind(dat)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    if(!is.null(preserve) & is.null(remove) & input$remove_selected_l1){
      preserve$series="Kept"
      dat<-rbind(dat,preserve)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    if(!is.null(preserve) & !is.null(remove) & input$remove_selected_l1){
      preserve$series="Kept"
      dat<-rbind(dat,preserve)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
      

    x_plot=unique(x_vals)
    y<-unique(predict(model_fit))
    dat_fit<-data.frame(model_fit=y[order(x_plot)],Date=x_plot[order(x_plot)],series="Model_Average")
    
    
    sp<-sp+ggtitle("RPM by Date after Filtering")+geom_line(data=dat_fit,aes(x=Date,y=model_fit,colour=series))+
      scale_color_manual(values=c("NonSelected"="blue","Removed"="red","Kept"="black","Model_Average"="black"))
    print(sp)
  } else{
    return(NULL)}
  
})

  output$l2_raw_plot<-renderPlot({
    if(!is.null(L2RAW())){
      dat=L2RAW()
      sp<-ggplot(dat,aes(x=Date,y=RPM))+geom_point(alpha=0.1,size=1)+
        ggtitle("Raw Data Selected for Lane")
      print(sp)} else{
        return(NULL)}
    
  })

output$stop_table2 <- renderUI({
  datset <- L2RAW()
  stopnames <- c("Lower Stop Count", "Upper Stop Count", "Avg RPM", "Avg Mileage")
  startvals <- c(min(datset[["Stop_Count"]]),max(datset[["Stop_Count"]]),1,1)
  stop_table<-data.frame(rbind(toupper(stopnames),startvals))
  if (!is.null(Read_Settings()[["stop_table2"]])){
    stop_table<-data.frame(Read_Settings()[["stop_table2"]])
  }
  
  if((!is.null(input$stop_table2)) && (nrow(input$stop_table2) >= 2)){
    valmatrix <- matrix(data = NA, nrow = nrow(input$stop_table2) - 1, ncol = 4)
    for (i in 2:nrow(input$stop_table2)){
      if(!(is.na(as.numeric(input$stop_table2[i,1])) | is.na(as.numeric(input$stop_table2[i,2])))){
        valmatrix[i-1,1] <- max(as.numeric(input$stop_table2[i,1]), startvals[1])
        valmatrix[i-1,2] <- min(as.numeric(input$stop_table2[i,2]), startvals[2])
        avgsub <- which(datset[["Stop_Count"]] %in% c(valmatrix[i-1,1]:valmatrix[i-1,2]))
        valmatrix[i-1,3] <- round(mean(datset[["RPM"]][avgsub]), digits = 3)
        valmatrix[i-1,4] <- round(mean(datset[["Total_Mileage"]][avgsub]), digits = 1)
      }
    }
    stop_table<-data.frame(rbind(toupper(stopnames),valmatrix))
  }
  
  matrixCustom('stop_table2', 'Rate and Mileage Between Stop Counts',stop_table)
  ###you can access these values with input$stop_table2 as the variable anywhere in the server side file
  
})

output$outlier_rpm2<-renderDataTable({
  L2()
  
})

output$outlier_rpm_plot2<-renderPlot({
  if(!is.null(SELECT_L2())){
    dat=SELECT_L2()[["data"]]
    model_fit=SELECT_L2()[["model_fit"]]
    x_vals=SELECT_L2()[["x_vals"]]
    remove=SELECT_L2()[["data_remove"]]
    if (empty(remove)){remove=NULL}
    preserve=SELECT_L2()[["data_preserve"]]
    if(empty(preserve)){preserve=NULL}
    dat$series="NonSelected"
    sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    
    
    if(!is.null(remove) & is.null(preserve) & !input$remove_selected_l2){
      remove$series="Removed"
      dat<-rbind(dat,remove)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
      
    }
    if(!is.null(preserve) & is.null(remove) & !input$remove_selected_l2){
      preserve$series="Kept"
      dat<-rbind(dat,preserve)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    if(!is.null(preserve) & !is.null(remove) & !input$remove_selected_l2){
      remove$series="Removed"
      preserve$series="Kept"
      dat<-rbind(dat,remove,preserve)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    
    if(!is.null(remove) & is.null(preserve) & input$remove_selected_l2){
      dat<-rbind(dat)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    if(!is.null(preserve) & is.null(remove) & input$remove_selected_l2){
      preserve$series="Kept"
      dat<-rbind(dat,preserve)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    if(!is.null(preserve) & !is.null(remove) & input$remove_selected_l2){
      preserve$series="Kept"
      dat<-rbind(dat,preserve)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    
    
    x_plot=unique(x_vals)
    y<-unique(predict(model_fit))
    dat_fit<-data.frame(model_fit=y[order(x_plot)],Date=x_plot[order(x_plot)],series="Model_Average")
    
    
    sp<-sp+ggtitle("RPM by Date after Filtering")+geom_line(data=dat_fit,aes(x=Date,y=model_fit,colour=series))+
      scale_color_manual(values=c("NonSelected"="blue","Removed"="red","Kept"="black","Model_Average"="black"))
    print(sp)
  } else{
    return(NULL)}
  
})


  output$l3_raw_plot<-renderPlot({
    if(!is.null(L3RAW())){
      dat=L3RAW()
      sp<-ggplot(dat,aes(x=Date,y=RPM))+geom_point(alpha=0.1,size=1)+
        ggtitle("Raw Data Selected for Lane")
      print(sp)} else{
        return(NULL)}
    
  })

output$stop_table3 <- renderUI({
  datset <- L3RAW()
  stopnames <- c("Lower Stop Count", "Upper Stop Count", "Avg RPM", "Avg Mileage")
  startvals <- c(min(datset[["Stop_Count"]]),max(datset[["Stop_Count"]]),1,1)
  stop_table<-data.frame(rbind(toupper(stopnames),startvals))
  if (!is.null(Read_Settings()[["stop_table3"]])){
    stop_table<-data.frame(Read_Settings()[["stop_table3"]])
  }
  
  if((!is.null(input$stop_table3)) && (nrow(input$stop_table3) >= 2)){
    valmatrix <- matrix(data = NA, nrow = nrow(input$stop_table3) - 1, ncol = 4)
    for (i in 2:nrow(input$stop_table3)){
      if(!(is.na(as.numeric(input$stop_table3[i,1])) | is.na(as.numeric(input$stop_table3[i,2])))){
        valmatrix[i-1,1] <- max(as.numeric(input$stop_table3[i,1]), startvals[1])
        valmatrix[i-1,2] <- min(as.numeric(input$stop_table3[i,2]), startvals[2])
        avgsub <- which(datset[["Stop_Count"]] %in% c(valmatrix[i-1,1]:valmatrix[i-1,2]))
        valmatrix[i-1,3] <- round(mean(datset[["RPM"]][avgsub]), digits = 3)
        valmatrix[i-1,4] <- round(mean(datset[["Total_Mileage"]][avgsub]), digits = 1)
      }
    }
    stop_table<-data.frame(rbind(toupper(stopnames),valmatrix))
  }
  
  matrixCustom('stop_table3', 'Rate and Mileage Between Stop Counts',stop_table)
  ###you can access these values with input$stop_table3 as the variable anywhere in the server side file
  
})

output$outlier_rpm3<-renderDataTable({
  L3()
  
})

output$outlier_rpm_plot3<-renderPlot({
  if(!is.null(SELECT_L3())){
    dat=SELECT_L3()[["data"]]
    model_fit=SELECT_L3()[["model_fit"]]
    x_vals=SELECT_L3()[["x_vals"]]
    remove=SELECT_L3()[["data_remove"]]
    if (empty(remove)){remove=NULL}
    preserve=SELECT_L3()[["data_preserve"]]
    if(empty(preserve)){preserve=NULL}
    dat$series="NonSelected"
    sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    
    
    if(!is.null(remove) & is.null(preserve) & !input$remove_selected_l3){
      remove$series="Removed"
      dat<-rbind(dat,remove)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
      
    }
    if(!is.null(preserve) & is.null(remove) & !input$remove_selected_l3){
      preserve$series="Kept"
      dat<-rbind(dat,preserve)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    if(!is.null(preserve) & !is.null(remove) & !input$remove_selected_l3){
      remove$series="Removed"
      preserve$series="Kept"
      dat<-rbind(dat,remove,preserve)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    
    if(!is.null(remove) & is.null(preserve) & input$remove_selected_l3){
      dat<-rbind(dat)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    if(!is.null(preserve) & is.null(remove) & input$remove_selected_l3){
      preserve$series="Kept"
      dat<-rbind(dat,preserve)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    if(!is.null(preserve) & !is.null(remove) & input$remove_selected_l3){
      preserve$series="Kept"
      dat<-rbind(dat,preserve)
      sp<-ggplot(dat,aes(x=Date,y=RPM,colour=series))+geom_point(alpha=0.35,size=1)
    }
    
    
    x_plot=unique(x_vals)
    y<-unique(predict(model_fit))
    dat_fit<-data.frame(model_fit=y[order(x_plot)],Date=x_plot[order(x_plot)],series="Model_Average")
    
    
    sp<-sp+ggtitle("RPM by Date after Filtering")+geom_line(data=dat_fit,aes(x=Date,y=model_fit,colour=series))+
      scale_color_manual(values=c("NonSelected"="blue","Removed"="red","Kept"="black","Model_Average"="black"))
    print(sp)
  } else{
    return(NULL)}
  
})

# output$mileagedate<-renderUI({
#   datset <- FINAL()
#   datset<-datset[datset[["Constructed_Lane"]] %in% gsub(".RPM","",input$response),]###this is needed with multiple lanes constructed to pull the response
#   
#   a=min(datset$Date)
#   b=max(datset$Date)
#   out1 <- dateRangeInput("mileagedate", "Date Cutoff Ranges for Mileage Summary:", 
#                          start =a, end =b )
#   if (!is.null(Read_Settings()[["mileagedate"]])) updateDateRangeInput(session, inputId= "mileagedate", start = Read_Settings()[["mileagedate"]][1], end = Read_Settings()[["mileagedate"]][2])
#   return(out1)
# })


output$mileage_table_current <- renderDataTable({
  
#   tree_result<-TREE_ADJUST()[["tree_result"]]
#   names<-paste(tree_result$bin_lower,tree_result$bin_upper,sep="-")
#   datset <- FINAL()
#   datset<-datset[datset[["Constructed_Lane"]] %in% gsub(".RPM","",input$response),]###this is needed with multiple lanes constructed to pull the response
#   idx1<-datset[["Date"]]>=input$mileagedate[1] & datset[["Date"]]<=input$mileagedate[2]
#   if(!is.null(tree_result)){
#     idx2 <- datset[["Stop_Count"]]>=tree_result$bin_lower[as.numeric(input$add_stop_ct)] & datset[["Stop_Count"]]<=tree_result$bin_upper[as.numeric(input$add_stop_ct)]
#     idx1 <- (idx1 & idx2)
#   }
  
  
  mileage <- quote_hist()[["allhistmileage"]]
  mileagesum <- summary(mileage)
  out1 <- rbind(mileagesum[1:6])
  colnames(out1) <- names(mileagesum[1:6])
  return(out1)
})
  
  output$lanes<-renderDataTable({
    FINAL()
    
  })
  
  output$weekly_averages<-renderDataTable({
    data.frame(LANE_BUNDLE()[['DATA_FILL']])
    
  })
  
  ###############################################
  ############### Current working outputs for bundles 3 - 5#####
  #########################################################
  
  output$Var_Import <- renderChart({
    pt_data<-mod()[["pt_data"]]
    names<-mod()[["names"]]
    response<-mod()[["response"]]
    fixed<-mod()[["fixed"]]
    #     theGraph<-barchart(pt_data,main=paste("Importance of Added Variable",sep=""),
    #                        sub=paste("Current Model: ",paste(names[c(response)]),"=",paste(names[c(fixed[-length(fixed)])],collapse=" + "),sep=""),
    #                        xlab="AIC of Model (shown below) with added Variable")
    #     print(theGraph)
    
    datatrans <- data.frame(pt_data[length(pt_data):1])
    datatrans <- data.frame(names(pt_data), datatrans, "top 25 selected_variables")
    colnames(datatrans) <- c("names","values", "selected_variables")
    levels(datatrans[[1]])<-datatrans[[1]]
    levels(datatrans[[1]])<-levels(datatrans[[1]])[nrow(datatrans):1]
    datatrans[[2]]<-datatrans[[2]][as.numeric(datatrans[[1]])]

    
  
    
    
    
    theGraph <- hPlot(values ~ names, data = datatrans, type = 'bar', group = 'selected_variables', group.na = 'NA\'s', title = "Importance of Added Variable")
    theGraph$xAxis(categories = c(levels(datatrans[,1])))
    theGraph$yAxis(title = (list(text = paste("AIC of Model (shown below) with added Variable <br> Current Model:",paste(names[c(response)]), "=",paste(names[c(fixed[-length(fixed)])],collapse=" + "), sep =""))))
    theGraph$addParams(dom = 'Var_Import')
    
    return(theGraph)
  })
  
  output$cond_effect <- renderPlot({
    fit_1<-mod()[["fit_1"]]
    x<-mod()[["x"]]
    run<-mod()[["run"]]
    theGraph<-plot(fit_1,pages=1,residuals=TRUE,shade=T)
    title(paste("Conditional Effects Plot:",colnames(x[run[1]])))
    print(theGraph)
    
  })
  
  output$diagnostic <- renderPlot({
    fit_1<-mod()[["fit_1"]]
    theGraph<-gam.check(fit_1)
    print(theGraph)
    
  })
  
  output$fit <- renderChart({
    fit_1<-mod()[["fit_1"]]
    date<-mod()[["date"]]
    ymin<-mod()[["ymin"]]
    ymax<-mod()[["ymax"]]
    x<-mod()[["x"]]
    response<-mod()[["response"]]
#     theGraph<-plot(predict(fit_1)~date,pch=16,ylim=c(ymin,ymax),ylab=colnames(x)[response])
#     lines(x[[response]]~date)
#     lines(predict(fit_1)~date,lty=2)
#     title("fitted versus observed")
#     legend(x="topleft",legend=c("fitted","observed"),
#            lty=c(2,1),lwd=c(0,1),pch=c(16,NA))
#     print(theGraph)

datatrans <- data.frame(date, predict(fit_1),x[[response]])
colnames(datatrans) <- c("date","fitted","observed")
datatrans <- reshape2::melt(datatrans,id= 'date', na.rm = TRUE)
datatrans[,1] <- as.numeric(as.POSIXct((as.numeric(datatrans[,1])*1000*24*60*60), origin = "1970-01-01"))     

theGraph <- hPlot(value ~ date, group = 'variable', data = datatrans, type = 'line', title = "Fitted vs. Observed")
theGraph$yAxis(title = (list(text = colnames(x)[response])))
theGraph$chart(zoomType = "x",height=600)
theGraph$addParams(dom = 'fit')
theGraph$xAxis(type = 'datetime', labels = list(format = '{value:%Y-%m-%d}'), title = list(text = "Date"))

return(theGraph)

    
  })

output$pred_fwd <- renderUI({
  tmp_dat<-mod()[["tmp_dat"]]
  
  # Call renderPlot for each one. Plots are only actually generated when they
  # are visible on the web page.
  for (i in 1:length(levels(mod()[["tmp_dat"]][["ind"]]))) {
    # Need local so that each item gets its own number. Without it, the value
    # of i in the renderPlot() will be the same across all instances, because
    # of when the expression is evaluated.
    local({
      my_i <- i
      plotname <- paste("plot", my_i, sep="")
      plotdat <- mod()[["tmp_dat"]]
      subdata <- plotdat[["ind"]] == levels(plotdat[["ind"]])[my_i]
      plotdat <- plotdat[subdata,]
      subdata <- plotdat[["plot_group"]] == levels(plotdat[["plot_group"]])[1]
      output[[plotname]] <- renderPlot({
        plot(plotdat[["plot_time"]][subdata], plotdat[["values"]][subdata], xlab = "Date", ylab = levels(plotdat[["ind"]])[my_i], xlim = range(plotdat[["plot_time"]]), ylim = range(plotdat[["values"]]), type = "o", lwd = 2)
        lines(plotdat[["plot_time"]][!subdata], plotdat[["values"]][!subdata], type = "o", col = "blue", lwd = 2)
      })
    })
  }
  
  ######Click listener for graphs below#####################
  
  for (i in 1:length(levels(mod()[["tmp_dat"]][["ind"]]))){
    local({
      my_i <- i
      # Listen for clicks
      observe({
        # Initially will be empty
        if (is.null(input[[paste0("click", levels(mod()[["tmp_dat"]][["ind"]])[my_i])]])){
          return()
        }
        isolate({
          clickname <- paste0("click", levels(mod()[["tmp_dat"]][["ind"]])[my_i])
          datetarget <- as.Date(as.POSIXct((input[[clickname]]$x)*24*60*60, origin = "1970-01-01"), format = "%Y-%m-%d")
                timediff <- abs(as.Date(input$table_values[,1]) - datetarget)
                if(min(timediff) <= 14){
                  replacetarget <- which.min(timediff)
                  if(length(which(predclickval$graphID %in%levels(mod()[["tmp_dat"]][["ind"]])[my_i])) == 0){
                    predclickval$graphID <- c(predclickval$graphID,levels(mod()[["tmp_dat"]][["ind"]])[my_i])
                    predclickval$target <- c(predclickval$target,replacetarget)
                    predclickval$value <- c(predclickval$value,input[[clickname]]$y)
                    predclickval$active <- c(predclickval$active,TRUE)
                  }
                  
                  lastclick <- max(which(predclickval$graphID %in%levels(mod()[["tmp_dat"]][["ind"]])[my_i]))
                  if(!((predclickval$target[lastclick] == replacetarget) & (predclickval$value[lastclick] == input[[clickname]]$y))){
                  predclickval$graphID <- c(predclickval$graphID,levels(mod()[["tmp_dat"]][["ind"]])[my_i])
                  predclickval$target <- c(predclickval$target,replacetarget)
                  predclickval$value <- c(predclickval$value,input[[clickname]]$y)
                  predclickval$active <- c(predclickval$active,TRUE)
                  }
                }
        })
      })
    })
  }
  
  plot_output_list <- lapply(1:length(levels(tmp_dat[["ind"]])), function(i) {
    plotname <- paste("plot", i, sep="")
    plotOutput(plotname, height = 500, width = 1000, clickId= paste("click", levels(tmp_dat[["ind"]])[i], sep = ""))
  })
  
  # Convert the list to a tagList - this is necessary for the list of items
  # to display properly.
  do.call(tagList, plot_output_list)
})

#   output$pred_fwd <- renderPlot({
#     tmp_dat<-mod()[["tmp_dat"]]
#     
#  
#     theGraph<-xyplot(values~plot_time|ind,group=plot_group,data=tmp_dat,scales=list(relation="free"),ylab=NULL,type=c("l","l"),
#                     lwd=5,pch=19,cex=0.01,col=c("gray","blue"),main="Observed and Predicted Values for Co-Variates",xlab="Date",
#                     distribute.type=TRUE)
#     
#     
# #     test1 <- data.frame(c(tmp_dat[["plot_time"]]),c(tmp_dat[["values"]]))
# #     theGraph <- plot(test1)
# #     print(theGraph)
# 
# # tmp_dat[["plot_time"]] <- as.numeric(as.POSIXct((as.numeric(tmp_dat[["plot_time"]])*1000*24*60*60), origin = "1970-01-01"))
# # theGraph <- hPlot(values ~ plot_time, group = 'plot_group', data = tmp_dat, type = 'line', title = "Observed and Predicted Values for Co-Variates")
# # theGraph$yAxis(title = (list(text = NULL)))
# # theGraph$xAxis(type = 'datetime', labels = list(format = '{value:%Y-%m-%d}'), title = list(text = "Date"))
# # theGraph$chart(zoomType = "x")
# # theGraph$addParams(dom = 'pred_fwd')
# # 
# # return(theGraph)
#     print(theGraph)
#   })

  output$ts_error <- renderPlot({
    predicted_vals<-mod()[["predicted_vals"]]
    theGraph<-fanchart(predicted_vals)
    print(theGraph)
    
  })
  
output$preds<- renderChart({
  predicted_vals<-mod()[["predicted_vals"]]
  smooth_vals<-mod()[["smooth_data"]]
  ZZ<-mod()[["ZZ"]]
  response<-mod()[["response"]]
  dateZZ<-mod()[["dateZZ"]]
  time_ahead<-mod()[["time_ahead"]]
  GAM_predictions<-mod()[["GAM_predictions"]]
  backcast_ahead<-mod()[["backcast_ahead"]]
  datexx<-mod()[["datexx"]]
  datatrans <- matrix(NA,nrow=nrow(smooth_vals),ncol = 4)
  idx<-smooth_vals[[5]]=="observed"
  
  datatrans[idx,1] <- smooth_vals[[2]][idx]
  datatrans[!idx,2] <- smooth_vals[[2]][!idx]
  datatrans[!idx,3] <- smooth_vals[[3]][!idx]
  datatrans[!idx,4] <- smooth_vals[[4]][!idx]
  datevect <- smooth_vals[[1]]
  datatrans <- data.frame(datevect,datatrans)
  
  
  CI_labs<-colnames(smooth_vals)[3:4]
  colnames(datatrans) <- c("date","observed","predicted",CI_labs)
  datatrans <- reshape2::melt(datatrans,id= 'date', na.rm = TRUE)
  datatrans[,1] <- as.numeric(as.POSIXct((as.numeric(datatrans[,1])*1000*24*60*60), origin = "1970-01-01"))
  theGraph <- hPlot(value ~ date, group = 'variable', data = datatrans, type = 'line')
  theGraph$chart(zoomType = "x",height=600)
  theGraph$xAxis(type = 'datetime', labels = list(format = '{value:%Y-%m-%d}'), title = list(text = "Date"))
  theGraph$addParams(dom = 'preds')
  theGraph$yAxis(title = list(text = names(predicted_vals$fcst[1])))
  
  return(theGraph)
  
}) 

########################### Temporary html only report download funciton using knit2html() since render() is having intermittent issues with pandoc installation ###############

output$downloadReport <- downloadHandler(
  filename = function() {
    paste('my-report', 'html', sep = '.')
  },
  
  content = function(file) {
    src <- normalizePath('report.Rmd')
    
    # temporarily switch to the temp dir, in case you do not have write
    # permission to the current working directory
    #owd <- setwd(tempdir())  ##you may need to turn these back
    #on.exit(setwd(owd)) ##same comment
    file.copy(src, 'report.Rmd')
    
    library(rmarkdown)
    out <- knit2html('report.Rmd')
    file.rename(out, file)
  }
)

#################### Original Report Download Function ##############################

# output$downloadReport <- downloadHandler(
#   filename = function() {
#     paste('my-report', sep = '.', switch(
#       input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
#     ))
#   },
#   
#   content = function(file) {
#     src <- normalizePath('report.Rmd')
#     
#     # temporarily switch to the temp dir, in case you do not have write
#     # permission to the current working directory
#     #owd <- setwd(tempdir())  ##you may need to turn these back
#     #on.exit(setwd(owd)) ##same comment
#     file.copy(src, 'report.Rmd')
#     
#     library(rmarkdown)
#     out <- render('report.Rmd', switch(
#       input$format,
#       PDF = pdf_document(), HTML = html_document(), Word = word_document()
#     ))
#     file.rename(out, file)
#   }
# )

######################################################################################
########################### FUCK           ###################################
######################################################################################
output$quote_final_title<-renderText({
  
  paste("Volume Weighted Average Quote for: ",input$quote_date[1]," - ",input$quote_date[2], sep="")
  
})

user_integ_vals <- reactive({
  smooth_vals<-mod()[["smooth_data"]]
  vol_vals<-vol_integrator()
  idxx<-smooth_vals[[5]]=="observed"
  smooth_vals_short <- smooth_vals[!idxx,]
  vol_vals_short <- vol_vals[!idxx,]
  user_vals_short <- cbind(as.Date(input$matrix_volume[,1]),as.numeric(input$matrix_volume[,2]),as.numeric(input$matrix_volume[,3]))
  
  for (i in 1:nrow(smooth_vals_short)){
    if(round(smooth_vals_short[i,2],2) != user_vals_short[i,2]){
      lcl_diff <- smooth_vals_short[i,3] - smooth_vals_short[i,2]
      ucl_diff <- smooth_vals_short[i,4] - smooth_vals_short[i,2]
      smooth_vals_short[i,2] <- user_vals_short[i,2]
      smooth_vals_short[i,3] <- user_vals_short[i,2] + lcl_diff
      smooth_vals_short[i,4] <- user_vals_short[i,2] + ucl_diff
    }
    if(round(vol_vals_short[i,2],2) != user_vals_short[i,3]){
      vol_vals_short[i,2] <- user_vals_short[i,3]
    }
  }
  
  smooth_vals[!idxx,] <- smooth_vals_short
  vol_vals[!idxx,] <- vol_vals_short
  
  outs <- structure(list("smooth_vals"=smooth_vals, "vol_vals"=vol_vals))
  return(outs)
  
})

quote_hist<-reactive({
  smooth_vals<-user_integ_vals()[["smooth_vals"]]
  vol_vals<-user_integ_vals()[["vol_vals"]]
  datset <- FINAL()
  datset<-datset[datset[["Constructed_Lane"]] %in% gsub(".RPM","",input$response),]###this is needed with multiple lanes constructed to pull the response
  tree_result<-TREE_ADJUST()[["tree_result"]]
  if(!is.null(tree_result)){
    idx11 <- datset[["Stop_Count"]]>=tree_result$bin_lower[as.numeric(input$add_stop_ct)] & datset[["Stop_Count"]]<=tree_result$bin_upper[as.numeric(input$add_stop_ct)]
    datset <- datset[idx11,]
  }
  
  datevect <- smooth_vals[[1]]
  idx<-datevect>=input$quote_date[1] & datevect<=input$quote_date[2]
  userdatesel <- input$matrix_volume[,1] >=input$quote_date[1] & input$matrix_volume[,1]<=input$quote_date[2]
  idxx<-smooth_vals[[5]]=="observed"
  CI_labs<-colnames(smooth_vals)[3:4]
  datatrans <- matrix(NA,nrow=nrow(smooth_vals),ncol = 2)
  datatrans[idxx,1] <- smooth_vals[[2]][idxx]
  #datatrans[idxx,2] <- vol_vals[[2]][idxx]
  datatrans[!idxx,2] <- as.numeric(input$matrix_volume[,2])
  #datatrans[!idxx,4] <- vol_vals[[2]][!idxx]
  datevect <- smooth_vals[[1]]
  datatrans <- data.frame(datevect,datatrans)
  smooth_vals_short <- smooth_vals[idx,]
  vol_vals_short <- vol_vals[idx,]
  
  rpm <- smooth_vals_short[[2]]
  volume <- vol_vals_short[[2]]
  intquote<-round(sum(rpm*volume,na.rm=T)/sum(volume,na.rm=T),2)
  intquoteLCL<-round(sum(smooth_vals_short[[3]]*volume,na.rm=T)/sum(volume,na.rm=T),2)
  intquoteUCL<-round(sum(smooth_vals_short[[4]]*volume,na.rm=T)/sum(volume,na.rm=T),2)
  
  rateavg<-round(mean(rpm,na.rm=T),2)
  rateavgLCL <- round(mean(smooth_vals_short[[3]],na.rm=T),2)
  rateavgUCL <- round(mean(smooth_vals_short[[4]],na.rm=T),2)
  
  startdate <- as.character(input$quote_date[1])
  enddate <- as.character(input$quote_date[2])
  
  volavg<-round(mean(volume,na.rm=T),2)
  quotetable <- data.frame(c("Mean", CI_labs[2], CI_labs[1]),c(intquote,intquoteUCL,intquoteLCL),c(rateavg,rateavgUCL,rateavgLCL),c(volavg,NA,NA), c(NA,NA,NA), c(startdate, startdate, startdate), c(enddate, enddate, enddate), stringsAsFactors = FALSE)
  colnames(quotetable) <- c("Value Type", "Volume Weighted RPM", "Rate per Mile", "Volume", "Average Total Mileage", "Start Date", "End Date")
  
  allhistmileage <- c()
  startdates <- c(as.POSIXlt(input$quote_date[[1]]), as.POSIXlt(input$quote_date[[2]]))
  datarange <- c(as.POSIXlt(min(smooth_vals[[1]])), as.POSIXlt(max(smooth_vals[[1]])))
  histdates <- c((datarange[2]$year - startdates[2]$year):(datarange[1]$year- startdates[1]$year))
  looprange <- startdates
  if(length(histdates) > 0){
    for (i in 1:length(histdates)){
      if(histdates[i] < 0){
        looprange[1]$year = startdates[1]$year + histdates[i]
        startjump <- looprange[1] - startdates[1]
        looprange[2]$year = startdates[2]$year + histdates[i]
        endjump <- looprange[2] - startdates[2]
        
        if(input$quote_date[1] + startjump >= min(smooth_vals[[1]])){
          
          idx<-datevect>=(input$quote_date[1] + startjump) & datevect<=(input$quote_date[2] + endjump)
          idx1<-datset[["Date"]]>=(input$quote_date[1] + startjump) & datset[["Date"]]<=(input$quote_date[2] + endjump)
          
          smooth_vals_short <- smooth_vals[idx,]
          vol_vals_short <- vol_vals[idx,]
          mileagevect <- datset[["Total_Mileage"]][idx1]
          allhistmileage <- c(allhistmileage, mileagevect)
          
          rpm <- smooth_vals_short[[2]]
          volume <- vol_vals_short[[2]]
          intquote<-round(sum(rpm*volume,na.rm=T)/sum(volume,na.rm=T),2)
          rateavg<-round(mean(rpm,na.rm=T),2)
          volavg<-round(mean(volume,na.rm=T),2)
          avgmileage <- round(mean(mileagevect,na.rm=T),0)
          
          startdate <- as.character(input$quote_date[1] + startjump)
          enddate <- as.character(input$quote_date[2] + endjump)
          
          quotetable <- rbind(quotetable, c(paste(looprange[1]$year + 1900, "Historical"), intquote, rateavg, volavg, avgmileage, startdate, enddate))
        }
      }
    }
  }
  
  outs <- structure(list("quotetable"=quotetable, "allhistmileage"=allhistmileage))
  return(outs)
  
})

output$quote_final<-renderDataTable({
  quotetable <- quote_hist()[["quotetable"]]
  return(quotetable)
  
})


output$hist_quote_chart<- renderChart({
  quotetable <- quote_hist()[["quotetable"]]
  graphset <- rbind(quotetable[1,], quotetable[4:nrow(quotetable),])
  graphset[1,1] <- paste(substr(graphset[1,5],0,4), "Predicted")
  graphset <- graphset[rev(rownames(graphset)),]

  theGraph <- Highcharts$new()
  theGraph$chart(zoomType = "x", height=600)
  theGraph$xAxis(categories = graphset[,1])
  theGraph$yAxis(title = list(text = "Rate Per Mile"),labels = list(format = '${value}'))
  theGraph$yAxis(title=list(text='Volume'), opposite='true',replace=F)
  theGraph$addParams(dom = 'hist_quote_chart')
  theGraph$series(name = 'Volume', type = 'column', data = as.numeric(graphset[,4]), yAxis = 1)
  theGraph$series(name = 'Rate', type = 'line', data = as.numeric(graphset[,3]), dashStyle = 'LongDash', yAxis = 0)
  theGraph$series(name = 'Volume Weighted RPM', type = 'line', data = as.numeric(graphset[,2]), yAxis = 0)
  
  return(theGraph)
  
})


######################################################################################
########################### FUCK           ###################################
######################################################################################
output$quote_value<- renderChart({
  smooth_vals<-user_integ_vals()[["smooth_vals"]]
  vol_vals<-user_integ_vals()[["vol_vals"]]
  CI_labs<-colnames(smooth_vals)[3:4]
  datevect <- smooth_vals[[1]]
  seldate<-datevect>=input$quote_date[1] & datevect<=input$quote_date[2]
  idxx<-smooth_vals[[5]]=="observed"
  
  datatrans <- matrix(NA,nrow=nrow(smooth_vals),ncol = 4)
  idx<-smooth_vals[[5]]=="observed"
  
  datatrans[idx,1] <- smooth_vals[[2]][idx]
  datatrans[!idx,2] <- smooth_vals[[2]][!idx]
  datatrans[!idx,3] <- smooth_vals[[3]][!idx]
  datatrans[!idx,4] <- smooth_vals[[4]][!idx]
  datatrans <- data.frame(datevect,datatrans)
  datatrans[,1] <- as.numeric(as.POSIXct((as.numeric(datatrans[,1])*1000*24*60*60), origin = "1970-01-01"))
  colnames(datatrans) <- c("date","observed","predicted",CI_labs)
  
  datatrans2 <- matrix(NA,nrow=nrow(smooth_vals),ncol = 2)
  datatrans2[idxx,1] <- vol_vals[[2]][idxx]
  datatrans2[!idxx,2]<-as.numeric(input$matrix_volume[,3])
  datatrans2 <- data.frame(datevect,datatrans2)
  datatrans2[,1] <- as.numeric(as.POSIXct((as.numeric(datatrans2[,1])*1000*24*60*60), origin = "1970-01-01"))
  colnames(datatrans2) <- c("date","Volume_observed","Volume_predicted")
  
  rateobs <- javalister(datatrans[idx,1:2])
  ratepreds <- javalister(cbind(datatrans[!idx,1], datatrans[!idx,3]))
  ratelcl <- javalister(cbind(datatrans[!idx,1], datatrans[!idx,4]))
  rateucl <- javalister(cbind(datatrans[!idx,1], datatrans[!idx,5]))
  volobs <- javalister(datatrans2[idxx,1:2])
  volpreds <- javalister(cbind(datatrans2[!idxx,1], datatrans2[!idxx,3]))
  
  rpm <- smooth_vals[[2]][seldate]
  volume <- vol_vals[[2]][seldate]
  quote<-round(mean(rpm,na.rm=T),2)
  quoteLCL <- round(mean(smooth_vals[[3]][seldate],na.rm=T),2)
  quoteUCL <- round(mean(smooth_vals[[4]][seldate],na.rm=T),2)  
  
startdates <- c(as.POSIXlt(input$quote_date[[1]]), as.POSIXlt(input$quote_date[[2]]))
datarange <- c(as.POSIXlt(min(smooth_vals[[1]])), as.POSIXlt(max(smooth_vals[[1]])))
histdates <- c((datarange[1]$year- startdates[1]$year): (datarange[2]$year - startdates[2]$year))
looprange <- startdates

plotbands <- list()

if(length(histdates) > 0){
  for (i in 1:length(histdates)){
    if(histdates[i] <= 0){  
    looprange[1]$year = startdates[1]$year + histdates[i]
      startjump <- looprange[1] - startdates[1]
      looprange[2]$year = startdates[2]$year + histdates[i]
      endjump <- looprange[2] - startdates[2]
      if(input$quote_date[1] + startjump >= min(smooth_vals[[1]])){
      plotbands[[length(plotbands)+1]] <- list(color='rgba(68, 170, 213, 0.2)',
                                               from=as.numeric(as.POSIXct((as.numeric((input$quote_date[1] + startjump))*1000*24*60*60), origin = "1970-01-01")),
                                               to=as.numeric(as.POSIXct((as.numeric((input$quote_date[2] + endjump))*1000*24*60*60), origin = "1970-01-01")))
      }
  }
  }
}

    theGraph <- Highcharts$new()
    theGraph$chart(zoomType = "x", height=600)
    theGraph$xAxis(type = 'datetime', labels = list(format = '{value:%Y-%m-%d}'), title = list(text = "Date"),
                   plotBands = plotbands)
    theGraph$yAxis(title = list(text = "Rate Per Mile"),labels = list(format = '${value}'))
    theGraph$yAxis(title=list(text='Volume'), opposite='true',replace=F)
    theGraph$addParams(dom = 'quote_value')
  theGraph$series(name = 'Observed Volume', type = 'line', data = volobs, yAxis = 1, turboThreshold = length(volobs), marker = list(enabled = FALSE), lineWidth = 0.5)
  theGraph$series(name = 'Predicted Volume', type = 'line', data = volpreds, yAxis = 1, turboThreshold = length(volpreds), marker = list(enabled = FALSE), lineWidth = 0.5)
  theGraph$series(name = 'Observed Rate', type = 'line', data = rateobs, yAxis = 0, turboThreshold = length(rateobs), marker = list(enabled = FALSE))
  theGraph$series(name = 'Predicted Rate', type = 'line', data = ratepreds, yAxis = 0, turboThreshold = length(ratepreds), marker = list(enabled = FALSE))
  theGraph$series(name = CI_labs[[1]], type = 'line', data = ratelcl, yAxis = 0, turboThreshold = length(ratelcl), marker = list(enabled = FALSE))
  theGraph$series(name = CI_labs[[2]], type = 'line', data = rateucl, yAxis = 0, turboThreshold = length(rateucl), marker = list(enabled = FALSE))
  
  return(theGraph)
  
})   





######################################################################################
########################### FUCK           ###################################
######################################################################################

  output$GAM_effects<-renderDataTable({
    tmp<-mod()[["Conditional_effects"]]
    #tmp$time_ahead<-format(as.POSIXct(tmp$time_ahead,origin="1970-01-01"),format="%m/%d/%Y")

  })
  
  output$effects <- downloadHandler(
    filename = c('effects.csv'),
    content = function(file) {
      write.csv(mod()[["Conditional_effects"]], file)
    })
  
  
  output$GAM_predictions<-renderDataTable({
    tmp<-mod()[["smooth_data"]]
    idx<-tmp[[5]]=="predicted"
    #tmp$time_ahead<-format(as.POSIXct(tmp$time_ahead,origin="1970-01-01"),format="%m/%d/%Y")
    tmp[idx,]
    
  })


output$vol_quote<-renderDataTable({
  volume<-vol_integrator()
  rate<-mod()[["smooth_data"]]
  data.frame(rate,volume)
})
  


  output$predictions_GAM <- downloadHandler(
    filename = c('predictions.csv'),
    content = function(file) {
      write.csv(mod()[["smooth_data"]], file)
    })
  
  
  
  
  output$Raw <- renderPlot({
    item=item()##identify reactive data
    PLOT=LANE_BUNDLE()[['PLOT']]
    
    #Original lattice based graphing    
        theGraph<-xyplot(values~as.POSIXlt(time,origin="1970-01-01")|ind,data=PLOT[which(PLOT$group %in% item),],scales=list(relation="free"),ylab=NULL,
                         lwd=1,pch=19,cex=0.01,xlab="Time",main=paste(item,sep=""))
    
    theGraph <- ggplot(PLOT[which(PLOT$group %in% item),], aes(time, values)) + geom_point(size = 1) + facet_wrap(~ind, scales = "free") + xlab("Time") + ylab(NULL)
    print(theGraph)
    
#     p1 <- rPlot(values~time|ind, data = PLOT[which(PLOT$group %in% item),], type = "point")

  })
  
  
  output$Impute <- renderPlot({
    item=item()##identify reactive data
    PLOT_FILL=LANE_BUNDLE()[['PLOT_FILL']]
    
    #Original Lattice-based graphing
    #    theGraph<-xyplot(values~as.POSIXlt(time,origin="1970-01-01")|ind,group=miss_index,data=PLOT_FILL[which(PLOT_FILL$group %in% item),],scales=list(relation="free"),ylab=NULL,
    #                     pch=c(19,19),col=c("black","red"),cex=c(0.05,0.5),xlab="Time",main=paste(item,sep=""),
    #                     key=list(text=list(c("imputed","observed")),columns=2,points=list(pch=c(19,19),col=c("black","red"))))
    
    theGraph <- ggplot(PLOT_FILL[which(PLOT_FILL$group %in% item),], aes(time, values, color = miss_index)) + geom_point(size= 1) + facet_wrap(~ind, scales = "free") + xlab("Time") + ylab(NULL)
    
    print(theGraph)
  })
  
  output$Backcast_graph <- renderChart({
    backcast_daily<-mod2()[["backcast_daily"]]
    percent_error<-mod2()[["percent_error"]]
    R<-mod2()[["R"]]
    smooth_vals<-mod()[["smooth_data"]]
    
    ZZ=mod()[['ZZ']]
    dateZZ=mod()[['dateZZ']]
    response=mod()[["response"]]
    TARGET_NAME=mod()[["TARGET_NAME"]]
    backcast_ahead=mod()[['backcast_ahead']]    
    
#     theGraph<-plot(ZZ[[response]]~dateZZ,type="l",xlim=c(min(c(dateZZ)),max(output_backcast[[1]])),
#                    ylim=c(min(ZZ[[response]],output_backcast[[2]],output_backcast[[3]],output_backcast[[4]]),
#                           max(ZZ[[response]],output_backcast[[2]],output_backcast[[3]],output_backcast[[4]])),
#                    ylab=colnames(ZZ)[response],main=paste(TARGET_NAME,":  Backasting Predictions",backcast_ahead,"Weeks Ahead"))
#     points(output_backcast[[2]]~output_backcast[[1]],pch=16,cex=1)
#     lines(output_backcast[[2]]~output_backcast[[1]],lwd=2,lty=1)
#     legend(x="topleft",legend=c("observed","predicted"),
#            lty=c(1,1),lwd=c(1,2),pch=c(NA,16))
#     title(sub=paste("Average Prediction Error=",round(percent_error,digits=4)*100,"%; R-Squared=",round(R,2),sep=""))
#     print(theGraph)
    
    observed <- smooth_vals[which(smooth_vals[,5] %in% "observed"),1:2]
    datatrans <- matrix(NA, nrow=nrow(observed)+nrow(backcast_daily),ncol = 2)
    datatrans[1:nrow(observed),1] <- observed[,2]
    datatrans[(nrow(observed)+1):nrow(datatrans),2] <- backcast_daily[,2]
    datevect <- c(observed[,1],backcast_daily[,1])
    datatrans <- data.frame(datevect,datatrans)
    
    colnames(datatrans) <- c("date","observed","predicted")
    datatrans <- reshape2::melt(datatrans,id= 'date', na.rm = TRUE)
    datatrans[,1] <- as.numeric(as.POSIXct((as.numeric(datatrans[,1])*1000*24*60*60), origin = "1970-01-01"))
    theGraph <- hPlot(value ~ date, group = 'variable', data = datatrans, type = 'line', title = paste(TARGET_NAME,":  Backasting Predictions",backcast_ahead,"Weeks Ahead"))
    theGraph$chart(zoomType = "x",height=600)
    theGraph$xAxis(type = 'datetime', labels = list(format = '{value:%Y-%m-%d}'), title = list(text = paste("Date <br>","Average Prediction Error=",round(percent_error,digits=4)*100,"%; R-Squared=",round(R,2),sep="")))
    theGraph$addParams(dom = 'Backcast_graph')
    theGraph$yAxis(title = list(text = colnames(ZZ)[response]))
    
    return(theGraph)
    
    
  })

  
})    
