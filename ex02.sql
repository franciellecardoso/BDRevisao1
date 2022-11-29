CREATE DATABASE ex02

GO
USE ex02

GO
CREATE TABLE carro(
placa                  VARCHAR(8)  UNIQUE     NOT NULL,
marca                  VARCHAR(10)            NOT NULL,
modelo                 VARCHAR(10)            NOT NULL,
cor                    VARCHAR(15)            NOT NULL,
ano                    INT                    NOT NULL,
PRIMARY KEY(placa) 
)

GO
CREATE TABLE cliente(
nome                   VARCHAR(40)            NOT NULL,
logradouro             VARCHAR(50)            NOT NULL,
numero                 INT                    NOT NULL,
bairro                 VARCHAR(30)            NOT NULL,
telefone               VARCHAR(8)             NOT NULL,
carro_placa_cliente    VARCHAR(8)             NOT NULL
PRIMARY KEY(carro_placa_cliente)
FOREIGN KEY(carro_placa_cliente) REFERENCES carro (placa)   
)

GO
CREATE TABLE peças (
codigo                 INT                    NOT NULL,
nome                   VARCHAR(30)            NOT NULL,
valor                  DECIMAL(7,2)           NOT NULL,
PRIMARY KEY(codigo)
)

GO
CREATE TABLE serviço (
carro_placa_serviço    VARCHAR(8)             NOT NULL,
peças_codigo           INT                    NOT NULL,
quantidade             INT                    NOT NULL,
valor                  DECIMAL(7,2)           NOT NULL,
data                   DATE                   NOT NULL
PRIMARY KEY(data, carro_placa_serviço, peças_codigo)
FOREIGN KEY(carro_placa_serviço)   REFERENCES carro(placa),
FOREIGN KEY(peças_codigo)  REFERENCES peças(codigo) 
)

--Dados carro
INSERT INTO carro (placa, marca, modelo, cor, ano)
VALUES            ('AFT9087', 'VW', 'Gol', 'Preto', 2007)

INSERT INTO carro (placa, marca, modelo, cor, ano)
VALUES            ('DXO9876', 'Ford', 'Ka', 'Azul', 2000)

INSERT INTO carro (placa, marca, modelo, cor, ano)
VALUES            ('EGT4631', 'Renault', 'Clio', 'Verde', 2004)

INSERT INTO carro (placa, marca, modelo, cor, ano)
VALUES            ('LKM7380', 'Fiat', 'Palio', 'Prata', 1997)

INSERT INTO carro (placa, marca, modelo, cor, ano)
VALUES            ('BCD7521', 'Ford', 'Fiesta', 'Preto', 1999)

--Dados cliente
INSERT INTO cliente (nome, logradouro, numero, bairro, telefone, carro_placa_cliente)
VALUES              ('João Alves', 'R. Pereira Barreto', 1258, 'Jd. Oliveiras', '21549658', 'DXO9876') 

INSERT INTO cliente (nome, logradouro, numero, bairro, telefone, carro_placa_cliente)
VALUES              ('Ana Maria', 'R. 7 de Setembro', 259, 'Centro', '96588541', 'LKM7380') 

INSERT INTO cliente (nome, logradouro, numero, bairro, telefone, carro_placa_cliente)
VALUES              ('Clara Oliveira', 'Av. Nações Unidas', 10254, 'Pinheiros', '24589658', 'EGT4631') 

INSERT INTO cliente (nome, logradouro, numero, bairro, telefone, carro_placa_cliente)
VALUES              ('José Simões', 'R. XV de Novembro', 36, 'Água Branca', '78952459', 'BCD7521') 

INSERT INTO cliente (nome, logradouro, numero, bairro, telefone, carro_placa_cliente)
VALUES              ('Paula Rocha', 'R. Anhaia', 548, 'Barra Funda', '69582548', 'AFT9087') 

--Dados peças
INSERT INTO peças (codigo, nome, valor)
VALUES            (1, 'Vela', 70) 

INSERT INTO peças (codigo, nome, valor)
VALUES            (2, 'Correia Dentada', 125) 

INSERT INTO peças (codigo, nome, valor)
VALUES            (3, 'Trambulador', 90) 

INSERT INTO peças (codigo, nome, valor)
VALUES            (4, 'Filtro de Ar', 30) 

--dados serviços
INSERT INTO serviço VALUES
       ('DXO9876', 1, 4, 280, '1/8/20'),
	   ('DXO9876', 4, 1, 30, '1/8/20'),
	   ('EGT4631', 3, 1, 90, '2/8/20'),
	   ('DXO9876', 2, 1, 125, '7/8/20')

SELECT * FROM carro
SELECT * FROM cliente
SELECT * FROM peças
SELECT * FROM serviços

--Consultar em Subqueries:
--Telefone do dono do carro Ka, Azul
SELECT telefone
FROM cliente
WHERE carro_placa_cliente IN 
 (
   SELECT placa
   FROM carro
   WHERE modelo = 'Ka' AND cor = 'Azul'
)



--Endereço concatenado do cliente que fez o serviço do dia 02/08/2009
SELECT logradouro +', Nº'+CAST(numero AS VARCHAR(5))+ ', ' + bairro AS endereço
FROM cliente
WHERE carro_placa_cliente IN 
(
  SELECT placa
  FROM carro
  WHERE placa IN 
  (
	SELECT carro_placa_serviço
    FROM serviço
	WHERE data = '02/08/2020'              	
    )
)
--Consulta:
--Placas dos carros de anos anteriores a 2001
SELECT placa
FROM carro
WHERE ano < 2001

--Marca, modelo e cor, concatenado dos carros posteriores a 2005
SELECT 'Marca ' + marca + ', Modelo ' + modelo + ', Cor ' + cor AS tipo_de_carro 
FROM carro
WHERE ano > 2005

--Código e nome das peças que custam menos de R$80,00
SELECT codigo, nome
FROM peças
WHERE valor < 80



