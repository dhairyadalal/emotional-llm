library(ggplot2)
library(RColorBrewer)


############################### [ Regression ] ##################################
data <- read.csv("results/regression-data.csv")


regression_anger <- lm(
  is_correct ~ wellbeing + self_control + emotionality + sociability, 
  data = data %>% filter(ekman == 'anger')
)

regression_fear <- lm(
  is_correct ~ wellbeing + self_control + emotionality + sociability, 
  data = data %>% filter(ekman == 'fear')
)

regression_happiness <- lm(
  is_correct ~ wellbeing + self_control + emotionality + sociability, 
  data = data %>% filter(ekman == "happiness")
)

regression_sadness <- lm(
  is_correct ~ wellbeing + self_control + emotionality + sociability, 
  data = data %>% filter(ekman == "sadness")
)

regression_surprise <- lm(
  is_correct ~ wellbeing + self_control + emotionality + sociability, 
  data = data %>% filter(ekman == "surprise")
)

# View the summaries of each regression
summary(regression_anger)
summary(regression_fear)
summary(regression_happiness)
summary(regression_sadness)
summary(regression_surprise)


library(broom)
# Gather the regression results for easy visualization
regression_results <- bind_rows(
  tidy(regression_anger) %>% mutate(emotion = "Anger"),
  tidy(regression_fear) %>% mutate(emotion = "Fear"),
  tidy(regression_happiness) %>% mutate(emotion = "Happiness"),
  tidy(regression_sadness) %>% mutate(emotion = "Sadness"),
  tidy(regression_surprise) %>% mutate(emotion = "Surprise")
) %>% na.omit()

# Filter out the intercept and plot the coefficients
ggplot(regression_results %>% filter(term != "(Intercept)"), aes(x = term, y = estimate, color = emotion)) +
  geom_point(size = 5) +
  geom_errorbar(aes(ymin = estimate - std.error, ymax = estimate + std.error), width = 0.2) +
  facet_wrap(~ emotion, scales = "free_y", nrow=2) +
  theme_classic() +
  labs(title = "",
       x = "Trait-based Factors",
       y = "Coefficient Estimate") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(
        axis.title=element_text(size=15),
        axis.text=element_text(size=15),
        legend.text=element_text(size=15),
        legend.position = "none", 
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5))

############################### [ Trait Chart ] ##################################
# Data for error bar chart
data <- data.frame(
  Model = rep(c("Human", "Gemma-2", "Mixtral", "Llama-3.1", "GPT4o"), each = 4),
  Trait = rep(c("Wellbeing", "Self-Control", "Emotionality", "Sociability"), times = 5),
  Mean = c(5.235, 4.475, 5.025, 4.905, 4.67, 4.5, 4.62, 4.67, 4.83, 3.83, 3.5, 3.67, 
           4.83, 3.33, 3.0, 3.67, 4.33, 4.33, 4.0, 4.83),
  SDev = c(0.83, 0.75, 0.71, 0.74, 2.16, 1.38, 1.6, 1.03, 2.99, 2.04, 1.69, 1.86, 
           2.32, 1.51, 1.77, 1.86, 1.86, 0.82, 1.2, 0.98)
)

# Reorder Model factor levels
data$Model <- factor(data$Model, levels = c("Human", "GPT4o", "Gemma-2", "Llama-3.1", "Mixtral"))

# Choose a color palette
colors <- brewer.pal(n = length(unique(data$Model)), name = "Set2")

ggplot(data, aes(x = Trait, y = Mean, color = Model)) +
  geom_point(size = 5) +
  coord_flip() +
  theme_clean() +
  labs(x = "Factor", y = "Score") +  
  scale_color_manual(values = colors) + 
  theme(axis.title=element_text(size=20),
        axis.text=element_text(size=20),
        legend.text=element_text(size=15),
        legend.position = "bottom", 
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5))

# Create error bar chart with dashed error bars and new color scheme
#ggplot(data, aes(x = Mean, y = Model, color = Model)) +  # Flip x and y coordinates
#  geom_point(size = 3, position = position_dodge(width = 0.5)) +  
#  geom_errorbar(
#    aes(xmin = Mean - SDev, xmax = Mean + SDev), 
#    height = 0.2, position = position_dodge(width = 0.5), linetype = "dashed") +  # Dashed horizontal error bars
#  facet_wrap(~ Trait, ncol = 1) +  # Create a facet for each trait in a single column
#  ggtitle("Trait-Based Emotional Factor Evaluation") +
#  theme_bw() +  # Use black and white theme
#  labs(x = "Score", y = "") +  
#  scale_color_manual(values = colors) +  # Apply the custom color palette
#  theme(axis.text.y = element_text(angle = 0, hjust = 1),  
#        legend.position = "none", 
#        legend.title = element_blank(),
#        plot.title = element_text(hjust = 0.5)) +
#  xlim(1, 8)  # Set x-axis limits to 1 and 7

############################### [   Chart ] ##################################
# Create the data frame
data <- data.frame(
  emotion = c("anger", "disgust", "fear", "happiness", "sadness", "surprise"),
  Gemma = c(0.3, 0.1, 0.33, 0.866, 0.571, 0.666),
  GPT4 = c(0.7, 1, 0.5, 0.933, 0.857, 0.666),
  Llama = c(0.4, 0.1, 0.5, 0.866, 0.571, 0.666),
  Mixtral = c(0.3, 1, 0.33, 0.8, 0.429, 0.666)
)

# Reshape the data into a long format
long_data <- melt(data, id.vars = "emotion", variable.name = "Model", value.name = "Score")

# Create the grouped bar chart
ggplot(long_data, aes(x = emotion, y = Score, fill = Model)) +
  geom_bar(stat = "identity", position = "dodge") +   # Creates grouped bar chart
  theme_classic() +
  labs(title = "Emotional Situation Awareness",
       x = "",
       y = "`Accuracy") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(axis.title=element_text(size=20),
        axis.text=element_text(size=20),
        legend.text=element_text(size=15),
        legend.position = "bottom", 
        legend.title = element_blank(),
        plot.title = element_text(hjust = 0.5, size=20))
