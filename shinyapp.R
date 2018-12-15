#be sure to declare any libraries or datasets first
salesdata <- read.csv("vgsales.csv")
#Build the UI.
ui <- fluidPage(
	titlePanel("Video Game Sales"),
	
		sidebarLayout(
		sidebarPanel(
			h3("Region"),
			selectInput("region", 
									label = "Choose a region",
									#These choices now need to be assigned numberical values so that they can be used to get real data later.
									choices = c("Global" = 11,
															"Japan" = 9,
															"North America" = 7,
															"Europe" = 8,
															"Other" = 10),
									selected = 11),
			h3("Name of Video Game"),
			textInput("videogamename", 
								label = "Type a video game",
								#added this to prevent crashing.
								value = "Wii Sports")

		),
			mainPanel(
		textOutput("selected_game"),
		textOutput("selected_region"),
		h1(textOutput("finalresult"))

		)
	)
)

# Define server logic ----
server <- function(input, output) {
  output$selected_game <- renderText({
  	paste("You are looking at data for:", input$videogamename)
  })
  
  #We have to get rid of this as it will now display a number. Commenting it out to show we got rid of it.
    #output$selected_region <- renderText({
  	#paste("In this region:", input$region)
  #})

    		  	#This is our grep code to find the user's query.
       searchresult <- reactive({
       	grep(paste("^", input$videogamename, "$"), salesdata$Name, ignore.case=TRUE)})
       #now to return the specific result, searchresult being the x axis and region input being the y axis.
			salesresult <-reactive({
				salesdata[searchresult, input$region]})

					
    output$finalresult <- renderText({
		paste(as.numeric(salesresult()), "million sales.")
    })
}

# Run the app ----
shinyApp(ui = ui, server = server)