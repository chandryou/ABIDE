library(keras)

####################################################
###LRCN ############################################
####################################################
# Parameters --------------------------------------------------------------

#Input Shape
input_shape = c(61,73,61)

# Embedding
max_features = 20000
maxlen = 100
embedding_size = 128

# Convolution
kernel_size = c(3,3,3)
filters = 128
pool_size = 4

# LSTM
lstm_output_size = 70

# Training
batch_size = 30
epochs = 2

# Data Preparation --------------------------------------------------------


# Defining Model ------------------------------------------------------
model <- keras::keras_model_sequential()

inputs<-keras::layer_input(shape = input_shape)

CNN3D <- keras::keras_model_sequential()

CNN3D%>%
    time_distributed(
                    layer_conv_3d(filters = 128,
                                  kernel_size = c(3,3,3),
                                  padding = "same",
                                  activation = "relu" #,strides =1
                    )
    ) %>%
    time_distributed(
        layer_conv_3d(filters = 256,
                      kernel_size = c(3,3,3),
                      padding = "same",
                      activation = "relu" #,strides =1
        )
    ) %>%
    time_distributed(
        layer_conv_3d(filters = 256,
                      kernel_size = c(3,3,3),
                      padding = "same",
                      activation = "relu" #,strides =1
        )
    ) %>%
    time_distributed(
        layer_max_pooling_3d(c(2,2,2))
    ) %>%
    time_distributed(
        layer_flatten()
    ) %>%
    time_distributed(
        layer_dense(units = 128)
    ) %>%
    layer_lstm() %>%
    layer_dense(units=2, activation='softmax')

CNN.Fc <- keras::keras_model_sequential()

CNN.Fc %>%
    layer_conv_2d(filters = 64,
                  kernel_size = c(4,4),
                  padding = "same",
                  activation = "relu" #,strides =1
                  ) %>%
    layer_conv_2d(filters = 64,
                  kernel_size = c(4,4),
                  padding = "same",
                  activation = "relu" #,strides =1
                  ) %>%
    layer_conv_2d(filters = 64,
                  kernel_size = c(4,4),
                  padding = "same",
                  activation = "relu" #,strides =1
                  ) %>%
    layer_max_pooling_2d(c(2,2)) %>%
    layer_flatten(128) %>%
    layer_dense(64, activation='softmax')

LRCN <- keras::keras_model_sequential()

LRCN <- CNN3D %>%
    {layer_concatenate(inputs = list(CNN.Fc,.), axis =3)} %>%
    layer_dense(units=2, activation='softmax')