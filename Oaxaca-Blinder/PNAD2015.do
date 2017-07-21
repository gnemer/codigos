################ LEIA-ME 


####### OBJETIVO: Importar dados da PNAD 2015, declarar variáveis importantes, eliminar NA's e realizar uma decomposição de Oaxaca-Blinder em duas partes (two-fold), para cada estado e esfera governamental, e para o setor público total de cada estado ##########

####### TEMPO: Cerca de 50 minutos

rm(list = ls())

library(bit64)
library(data.table)
library(descr)
library(xlsx)
library(readr)
library(survey)
library(checkmate)
library(lme4)
library(oaxaca)

################ CAMINHO DOS ARQUIVOS 

###### MUDE OS CAMINHOS ABAIXO


pasta_resultados <- "c:/temp/" ##### ONDE ARMAZENAR OS RESULTADOS?

pasta_dados <- "c:/temp/PNAD/PES2015.txt" ###### CAMINHO DO ARQUIVO DOS DADOS


printf <- function(...) cat(sprintf(...))

##### TAMANHO E NOME DAS VARIÁVEIS

sizes <- c(4,2,6,3,2,1,2,2,4,3,1,1,1,1,1,1,2,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,5,1,4,5,1,1,12,1,12,1,1,2,1,2,1,1,1,1,1,1,4,5,2,1,1,1,1,1,1,1,1,1,11,7,1,11,7,1,11,7,1,1,1,1,1,11,7,1,11,7,1,11,7,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,12,1,12,1,1,1,1,1,1,1,1,2,1,1,2,2,1,1,2,1,1,1,1,1,1,4,5,2,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,4,5,1,1,1,1,1,1,1,12,1,12,1,1,1,2,1,12,1,12,1,1,1,1,2,1,1,1,2,2,4,5,1,1,1,1,1,1,1,1,1,1,2,1,1,1,2,12,2,12,2,12,2,12,2,12,2,12,2,12,2,12,1,1,2,2,2,2,1,1,2,2,1,1,1,2,4,1,1,2,2,1,1,1,2,2,2,1,1,2,1,1,2,2,1,1,1,1,2,2,2,12,12,12,12,12,2,2,1,1,5,5,1,1,1,2,12,2,1,1,1,1,1,12,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5,5,1,1,1,1,1,2,1,1,5,1,1,1,1,1,1,1,1,1,5,2,1,1,1,1,2,1,5,1,1,1,1,1,1,1,1,1,5,5,8)

names <- c("V0101","UF","V0102","V0103","V0301","V0302","V3031","V3032","V3033","V8005","V0401","V0402","V0403","V0404","V0405","V0406","V0407","V0408","V4111","V4112","V4011","V0412","V0501","V0502","V5030","V0504","V0505","V5061","V5062","V5063","V5064","V5065","V0507","V5080","V5090","V0510","V0511","V5121","V5122","V5123","V5124","V5125","V5126","V0601","V0602","V6002","V6020","V6003","V6030","V0604","V0605","V0606","V6007","V6070","V0608","V0609","V0610","V0611","V06111","V061111","V061112","V061113","V061114","V061115","V061116","V06112","V0612","V0701","V0702","V0703","V0704","V0705","V7060","V7070","V0708","V7090","V7100","V0711","V7121","V7122","V7124","V7125","V7127","V7128","V0713","V0714","V0715","V0716","V9001","V9002","V9003","V9004","V9005","V9906","V9907","V9008","V9009","V9010","V90101","V9011","V9012","V90121","V9013","V9014","V9151","V9152","V9154","V9156","V9157","V9159","V9161","V9162","V9164","V9016","V9017","V9018","V9019","V9201","V9202","V9204","V9206","V9207","V9209","V9211","V9212","V9214","V9021","V9022","V9023","V9024","V9025","V9026","V9027","V9028","V9029","V9030","V9031","V9032","V9033","V9034","V9035","V9036","V9037","V9038","V9039","V9040","V9041","V9042","V9043","V9044","V9045","V9046","V9047","V9048","V9049","V9050","V9051","V9052","V9531","V9532","V9534","V9535","V9537","V90531","V90532","V90533","V9054","V9055","V9056","V9057","V9058","V9059","V9060","V9611","V9612","V9062","V9063","V9064","V9065","V9066","V9067","V9068","V9069","V9070","V9971","V9972","V9073","V9074","V9075","V9076","V9077","V9078","V9079","V9080","V9081","V9082","V9083","V9084","V9085","V9861","V9862","V9087","V90871","V908721","V908722","V908723","V908724","V908725","V908726","V90873","V90874","V9088","V90881","V90882","V908831","V908832","V908833","V908834","V908835","V908836","V908837","V90884","V908851","V908852","V908853","V908854","V908855","V908856","V90886","V90887","V908881","V908882","V908883","V908884","V908885","V908886","V908887","V9891","V9892","V9990","V9991","V9092","V9093","V9094","V9095","V9096","V9097","V9981","V9982","V9984","V9985","V9987","V9099","V9100","V9101","V1021","V1022","V1024","V1025","V1027","V1028","V9103","V9104","V9105","V9106","V9107","V9108","V1091","V1092","V9910","V9911","V9112","V9113","V9114","V9115","V9116","V9117","V9118","V9119","V9120","V9121","V9921","V9122","V9123","V9124","V1251","V1252","V1254","V1255","V1257","V1258","V1260","V1261","V1263","V1264","V1266","V1267","V1269","V1270","V1272","V1273","V9126","V1101","V1141","V1142","V1151","V1152","V1153","V1154","V1161","V1162","V1163","V1164","V1107","V1181","V1182","V1109","V1110","V1111","V1112","V1113","V1114","V1115","V4801","V4802","V4803","V4704","V4805","V4706","V4707","V4808","V4809","V4810","V4711","V4812","V4713","V4814","V4715","V4816","V4817","V4718","V4719","V4720","V4721","V4722","V4723","V4724","V4727","V4728","V4729","V4732","V4735","V4838","V6502","V4741","V4742","V4743","V4745","V4746","V4747","V4748","V4749","V4750","V38011","V38012","V3802","V3803","V3804","V3805","V3806","V3807","V3808","V3809","V37001","V37002","V3701","V3702","V3703","V3704","V3705","V3706","V37071","V37072","V37073","V37074","V37075","V37091","V37092","V37093","V37094","V37095","V37096","V37097","V37098","V3719","V3720","V36001","V36002","V3601","V3602","V3603","V3604","V3605","V3606","V3607","V3608","V3609","V3610","V3611","V3612","V3613","V3614","V3615","V3616","V3617","V3618","V3619","V3620","V3621","V3622","V3623","V3624","V3625","V3626","V3627","V3628","V3629","V3630","V3631","V3632","V3633","V3634","V3637","V3638","V9993")

##### IMPORTAR DADOS

pes <- read_fwf(file = pasta_dados, fwf_widths(sizes))

names(pes) <- names

options("scipen" = 12)

## transforma em numerico

pes$V4809 <- as.numeric(pes$V4809)
pes$V4715 <- as.numeric(pes$V4715)
pes$V0404 <- as.numeric(pes$V0404)
pes$V4814 <- as.numeric(pes$V4814)
pes$V4803 <- as.numeric(pes$V4803)
pes$V4810 <- as.numeric(pes$V4810)
pes$V4718 <- as.numeric(pes$V4718)
pes$V9611 <- as.numeric(pes$V9611)
pes$V9612 <- as.numeric(pes$V9612)
pes$V9087 <- as.numeric(pes$V9087)
pes$V0302 <- as.numeric(pes$V0302)
pes$V8005 <- as.numeric(pes$V8005)
pes$V9058 <- as.numeric(pes$V9058)
pes$V9032 <- as.numeric(pes$V9032)
pes$V9892 <- as.numeric(pes$V9892)
pes$V9033 <- as.numeric(pes$V9033)
pes$V9030 <- as.numeric(pes$V9030)
pes$V4728 <- as.numeric(pes$V4728)
pes$V4817 <- as.numeric(pes$V4817)
pes$V4706 <- as.numeric(pes$V4706)
pes$V4805 <- as.numeric(pes$V4805)
pes$V4729 <- as.numeric(pes$V4729)

## muda NA de esfera

pes$V9033[is.na(pes$V9033)] <- 0
pes$V0502[is.na(pes$V0502)] <- 0
pes$V4011[is.na(pes$V4011)] <- 99

####### FORMULAS

##### CALCULO DO P-VALOR

pvalor <- function(x) {
if(x < 0) {
valorp <- pt(x, df = dfs, lower.tail = T)*2
return(valorp)
} else
valorp <- pt(x, df = dfs, lower.tail = F)*2
return(valorp)
}

estados <- c("RO", "AC", "AM", "RR", "PA", "AP", "TO", "MA", "PI", "CE", "RN", "PB", "PE", "AL", "SE", "BA", "MG", "ES", "RJ", "SP", "PR", "SC", "RS", "MS", "MT", "GO", "DF")

#### FEDERAL


federal <- paste(pasta_resultados,"federal.xlsx", sep = "")


### vetores
coeficientes_explicado <- c(1)
erros_padrao_explicado <- c(1)
coeficientes_inexplicado <- c(1)
erros_padrao_inexplicado <- c(1)
tcs <- c(1)
pvalues_explicado <- c(1)
pvalues_inexplicado <- c(1)


########## RONDONIA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 11 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## ACRE

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 12 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## AMAZONAS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 13 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RORAIMA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 14 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PARÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 15 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## AMAPÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 16 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## TOCANTINS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 17 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MARANHÃO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 21 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PIAUÍ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 22 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## CEARÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 23 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RIO GRANDE DO NORTE

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 24 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PARAÍBA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 25 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PERNAMBUCO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 26 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## ALAGOAS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 27 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## SERGIPE

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 28 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## BAHIA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 29 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MINAS GERAIS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 31 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## ESPÍRITO SANTO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 32 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RIO DE JANEIRO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 33 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## SÃO PAULO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 35 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PARANÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 41 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## SANTA CATARINA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 42 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RIO GRANDE DO SUL

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 43 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MATO GROSSO DO SUL

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 50 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MATO GROSSO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 51 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## GOIÁS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 52 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## DISTRITO FEDERAL

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 53 & (pes$V9033 == 0 | pes$V9033 == 1) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

coeficientes_explicado <- coeficientes_explicado[-1]
erros_padrao_explicado <- erros_padrao_explicado[-1]
coeficientes_inexplicado <- coeficientes_inexplicado[-1]
erros_padrao_inexplicado <- erros_padrao_inexplicado[-1]
tcs <- tcs[-1]
pvalues_explicado <- pvalues_explicado[-1]
pvalues_inexplicado <- pvalues_inexplicado[-1]

matriz <- cbind(estados, coeficientes_explicado, erros_padrao_explicado, coeficientes_inexplicado, erros_padrao_inexplicado, pvalues_explicado, pvalues_inexplicado, tcs)

matriz <- data.frame(matriz)

nomes <- c("Estados", "Coef(explained)", "S.E. (explained)", "Coef(unexplained)", "S.E. (unexplained)", "P-value (explained)", "P-value (unexplained)", "Tc")

names(matriz) <- nomes

write.xlsx(matriz, file = federal)


#### FIM DA PARTE FEDERAL

#### ESTADUAL

estadual <- paste(pasta_resultados,"estadual.xlsx", sep = "")


### vetores
coeficientes_explicado <- c(1)
erros_padrao_explicado <- c(1)
coeficientes_inexplicado <- c(1)
erros_padrao_inexplicado <- c(1)
tcs <- c(1)
pvalues_explicado <- c(1)
pvalues_inexplicado <- c(1)


########## RONDONIA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 11 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## ACRE

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 12 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## AMAZONAS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 13 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RORAIMA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 14 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PARÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 15 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## AMAPÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 16 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## TOCANTINS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 17 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MARANHÃO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 21 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PIAUÍ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 22 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## CEARÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 23 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RIO GRANDE DO NORTE

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 24 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PARAÍBA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 25 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PERNAMBUCO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 26 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## ALAGOAS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 27 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## SERGIPE

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 28 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## BAHIA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 29 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MINAS GERAIS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 31 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## ESPÍRITO SANTO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 32 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RIO DE JANEIRO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 33 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## SÃO PAULO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 35 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PARANÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 41 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## SANTA CATARINA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 42 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RIO GRANDE DO SUL

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 43 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MATO GROSSO DO SUL

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 50 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MATO GROSSO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 51 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## GOIÁS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 52 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## DISTRITO FEDERAL

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 53 & (pes$V9033 == 0 | pes$V9033 == 3) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

coeficientes_explicado <- coeficientes_explicado[-1]
erros_padrao_explicado <- erros_padrao_explicado[-1]
coeficientes_inexplicado <- coeficientes_inexplicado[-1]
erros_padrao_inexplicado <- erros_padrao_inexplicado[-1]
tcs <- tcs[-1]
pvalues_explicado <- pvalues_explicado[-1]
pvalues_inexplicado <- pvalues_inexplicado[-1]

matriz <- cbind(estados, coeficientes_explicado, erros_padrao_explicado, coeficientes_inexplicado, erros_padrao_inexplicado, pvalues_explicado, pvalues_inexplicado, tcs)

matriz <- data.frame(matriz)

nomes <- c("Estados", "Coef(explained)", "S.E. (explained)", "Coef(unexplained)", "S.E. (unexplained)", "P-value (explained)", "P-value (unexplained)", "Tc")

names(matriz) <- nomes

write.xlsx(matriz, file = estadual)


#### FIM DA PARTE ESTADUAL

#### MUNICIPAL


municipal <- paste(pasta_resultados,"municipal.xlsx", sep = "")

### vetores
coeficientes_explicado <- c(1)
erros_padrao_explicado <- c(1)
coeficientes_inexplicado <- c(1)
erros_padrao_inexplicado <- c(1)
tcs <- c(1)
pvalues_explicado <- c(1)
pvalues_inexplicado <- c(1)


########## RONDONIA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 11 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## ACRE

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 12 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## AMAZONAS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 13 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RORAIMA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 14 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PARÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 15 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## AMAPÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 16 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## TOCANTINS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 17 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MARANHÃO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 21 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PIAUÍ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 22 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## CEARÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 23 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RIO GRANDE DO NORTE

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 24 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PARAÍBA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 25 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PERNAMBUCO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 26 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## ALAGOAS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 27 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## SERGIPE

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 28 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## BAHIA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 29 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MINAS GERAIS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 31 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## ESPÍRITO SANTO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 32 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RIO DE JANEIRO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 33 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## SÃO PAULO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 35 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PARANÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 41 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## SANTA CATARINA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 42 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RIO GRANDE DO SUL

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 43 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MATO GROSSO DO SUL

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 50 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MATO GROSSO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 51 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## GOIÁS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 52 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## DISTRITO FEDERAL

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 53 & (pes$V9033 == 0 | pes$V9033 == 5) & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

coeficientes_explicado <- coeficientes_explicado[-1]
erros_padrao_explicado <- erros_padrao_explicado[-1]
coeficientes_inexplicado <- coeficientes_inexplicado[-1]
erros_padrao_inexplicado <- erros_padrao_inexplicado[-1]
tcs <- tcs[-1]
pvalues_explicado <- pvalues_explicado[-1]
pvalues_inexplicado <- pvalues_inexplicado[-1]

matriz <- cbind(estados, coeficientes_explicado, erros_padrao_explicado, coeficientes_inexplicado, erros_padrao_inexplicado, pvalues_explicado, pvalues_inexplicado, tcs)

matriz <- data.frame(matriz)

nomes <- c("Estados", "Coef(explained)", "S.E. (explained)", "Coef(unexplained)", "S.E. (unexplained)", "P-value (explained)", "P-value (unexplained)", "Tc")

names(matriz) <- nomes

write.xlsx(matriz, file = municipal)

##### FIM DA PARTE MUNICIPAL

#### SETOR PÚBLICO TOTAL

setorpublico <- paste(pasta_resultados,"setorpublico.xlsx", sep = "")

### vetores
coeficientes_explicado <- c(1)
erros_padrao_explicado <- c(1)
coeficientes_inexplicado <- c(1)
erros_padrao_inexplicado <- c(1)
tcs <- c(1)
pvalues_explicado <- c(1)
pvalues_inexplicado <- c(1)


########## RONDONIA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 11  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## ACRE

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 12  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## AMAZONAS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 13  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RORAIMA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 14  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PARÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 15  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## AMAPÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 16  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## TOCANTINS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 17  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MARANHÃO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 21  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PIAUÍ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 22  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## CEARÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 23  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RIO GRANDE DO NORTE

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 24  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PARAÍBA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 25  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PERNAMBUCO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 26  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## ALAGOAS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 27  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## SERGIPE

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 28  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## BAHIA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 29  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MINAS GERAIS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 31  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## ESPÍRITO SANTO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 32  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RIO DE JANEIRO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 33  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## SÃO PAULO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 35  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## PARANÁ

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 41  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## SANTA CATARINA

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 42  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## RIO GRANDE DO SUL

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 43  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MATO GROSSO DO SUL

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 50  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## MATO GROSSO

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 51  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## GOIÁS

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 52  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

########## DISTRITO FEDERAL

#variaveis de peso

estado <- pes$UF
peso <- pes$V4729
controle <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, pes$V0301, sep = "")
controle <- as.numeric(controle)
controlefam <- paste(pes$UF, pes$V0102, pes$V0103, pes$V0403, sep = "")
controlefam <- as.numeric(controlefam)
controledom <- paste(pes$UF, pes$V0102, pes$V0103, sep = "")
controledom <- as.numeric(controledom)


filtro <- estado == 53  & pes$V4810 != 9 & !is.na(pes$V4706) & !is.na(pes$V9611) & !is.na(pes$V9612) & pes$V0404 != 9 & pes$V4805 == 1 & !is.na(pes$V4805) & pes$V4718 != 0 & pes$V4718 != 999999999999 & !is.na(pes$V4718) & !is.na(pes$V9058) & pes$V4803 != 17 & !is.na(pes$V4803) & (pes$V4706 == 1 | pes$V4706 == 3 | pes$V4706 == 4) & !is.na(pes$V4729) & !is.na(pes$V9087) & pes$V4810 != 7 & !is.na(pes$V4810) 

## pesV9032 E 9033 indicam setor e esfera

sindicato <- pes$V9087[filtro]
estado <- estado[filtro]
sexo <- pes$V0302[filtro]
idade <- pes$V8005[filtro]
cor <- pes$V0404[filtro]
renda <- pes$V4718[filtro]
horas <- pes$V9058[filtro]
educacao <- pes$V4803[filtro]
ocupacao <- pes$V4706[filtro]
peso <- pes$V4729[filtro]
controle <- controle[filtro]
setor <- pes$V9032[filtro]
esfera <- pes$V9033[filtro]
tenure1 <- pes$V9611[filtro]
tenure2 <- pes$V9612[filtro]
migrante <- pes$V0502[filtro]
civil <- pes$V4011[filtro]
atividade <- pes$V4810[filtro]

peso <- as.numeric(peso)
estado <- as.numeric(estado)
sexo <- as.numeric(sexo)
idade <- as.numeric(idade)
cor <- as.numeric(cor)
renda <- as.numeric(renda)
horas <- as.numeric(horas)
ocupacao <- as.numeric(ocupacao)
educacao <- as.numeric(educacao)
esfera <- as.numeric(esfera)
setor <- as.numeric(setor)
controle <- as.numeric(controle)
tenure1 <- as.numeric(tenure1)
tenure2 <- as.numeric(tenure2)
migrante <- as.numeric(migrante)
civil <- as.numeric(civil)
atividade <- as.numeric(atividade)


horas <- horas/7
horas <- 30*horas

tenure1 <- 12*tenure1
tenure <- (tenure1 + tenure2)/12




rendahora <- renda/horas

#sexo com referencia mulher

homem <- as.numeric(sexo == 2)

# etnia com referencia não-branco

branco <- as.numeric(cor == 2)


idadequadrado <- idade^2




## setor


publico <- as.numeric(esfera > 0)
privado <- as.numeric(esfera == 0)


## carreira com referencia 'demais'

qualificados <- as.numeric(atividade == 1 | atividade == 2)
tecnicos <- as.numeric(atividade == 3 | atividade == 4)
demais <- as.numeric(atividade == 5 | atividade == 6 | atividade == 8 | atividade == 9 | atividade == 10)


### extras

rendahora <- log(rendahora)

educacao <- educacao - 1

educacaoquadrado <- educacao^2

migrante <- as.numeric(migrante == 4)

casado <- as.numeric(civil == 1 | civil == 99)

sindicato <- as.numeric(sindicato == 1)

dados <- data.frame(rendahora, sindicato, tenure, educacao, educacaoquadrado, homem, branco, idade, idadequadrado, migrante, casado, qualificados, tecnicos, demais, publico, privado)

minha_formula_estado <- rendahora ~ homem + branco + idade + idadequadrado + educacao + educacaoquadrado + tenure + sindicato + migrante + casado + qualificados + tecnicos | privado

set.seed(7)

oaxaca <- oaxaca(formula = minha_formula_estado, data = dados, R = 1000)

dfs <- sum(publico) + sum(privado) - 26

coef_explicado <- (oaxaca$twofold$overall)[[1,2]]
std_error_explicado <- (oaxaca$twofold$overall)[[1,3]]
coef_inexplicado <- (oaxaca$twofold$overall)[[1,4]]
std_error_inexplicado <- (oaxaca$twofold$overall)[[1,5]]

coeficientes_explicado <- append(coeficientes_explicado, coef_explicado)
erros_padrao_explicado <- append(erros_padrao_explicado, std_error_explicado)
coeficientes_inexplicado <- append(coeficientes_inexplicado, coef_inexplicado)
erros_padrao_inexplicado <- append(erros_padrao_inexplicado, std_error_inexplicado)

t_explicado <- coef_explicado/std_error_explicado
t_inexplicado <- coef_inexplicado/std_error_inexplicado

p_value_explicado <- pvalor(t_explicado)
p_value_inexplicado <- pvalor(t_inexplicado)

pvalues_explicado <- append(pvalues_explicado, p_value_explicado)
pvalues_inexplicado <- append(pvalues_inexplicado, p_value_inexplicado)

tc <- qt(0.975, df = dfs)

tcs <- append(tcs, tc)

coeficientes_explicado <- coeficientes_explicado[-1]
erros_padrao_explicado <- erros_padrao_explicado[-1]
coeficientes_inexplicado <- coeficientes_inexplicado[-1]
erros_padrao_inexplicado <- erros_padrao_inexplicado[-1]
tcs <- tcs[-1]
pvalues_explicado <- pvalues_explicado[-1]
pvalues_inexplicado <- pvalues_inexplicado[-1]

matriz <- cbind(estados, coeficientes_explicado, erros_padrao_explicado, coeficientes_inexplicado, erros_padrao_inexplicado, pvalues_explicado, pvalues_inexplicado, tcs)

matriz <- data.frame(matriz)

nomes <- c("Estados", "Coef(explained)", "S.E. (explained)", "Coef(unexplained)", "S.E. (unexplained)", "P-value (explained)", "P-value (unexplained)", "Tc")

names(matriz) <- nomes

write.xlsx(matriz, file = setorpublico)
