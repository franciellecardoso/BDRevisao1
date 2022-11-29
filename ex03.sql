CREATE DATABASE ex03

GO 
use ex03

GO
CREATE TABLE paciente(
CPF                VARCHAR(11)           NOT NULL,
nome               VARCHAR(30)           NOT NULL,
Rua                VARCHAR(30)           NOT NULL,
N�                 INT                   NOT NULL,
bairro             VARCHAR(30)           NOT NULL,
telefone           VARCHAR(8)            NULL,
data_Nasc          DATE                  NOT NULL
PRIMARY KEY (CPF)
)

GO
CREATE TABLE medico (
codigo             INT                   NOT NULL,
nome               VARCHAR(30)           NOT NULL,
especialidade      VARCHAR(20)           NOT NULL
PRIMARY KEY (codigo)
)

GO
CREATE TABLE prontuario (
data               DATE                  NOT NULL,
CPF_paciente       VARCHAR(11)           NOT NULL,
codigo_medico      INT                   NOT NULL,
diagnostico        VARCHAR(30)           NOT NULL,
medicamento        VARCHAR(20)           NOT NULL
PRIMARY KEY (data, CPF_paciente, codigo_medico)
FOREIGN KEY (CPF_paciente) REFERENCES paciente (CPF),
FOREIGN KEY (codigo_medico) REFERENCES medico (codigo)
)

--Dados paciente
INSERT INTO paciente VALUES
             ('35454562890', 'Jos� Rubens', 'Campos Salles', 2750, 'Centro', '21450998', '1954-10-18'),
			 ('29865439810', 'Ana Claudia', 'Sete de Setembro', 178, 'Centro', '97382764', '1960-05-29'),
			 ('82176534800', 'Marcos Aur�lio', 'Tim�teo Penteado', 236, 'Vila Galv�o', '68172651', '1980-09-24'),
			 ('12386758770', 'Maria Rita', 'Castello Branco', 7765, 'Vila Ros�lia', NULL, '1975-03-30'),
			 ('92173458910', 'Joana de Souza', 'XV de Novembro', 298, 'Centro', '21276578', '1944-04-24')

--Dados medico
INSERT INTO medico (codigo, nome, especialidade)
VALUES             (1, 'Wilson Cesar', 'Pediatra')

INSERT INTO medico (codigo, nome, especialidade)
VALUES             (2, 'Marcia Matos', 'Geriatra')

INSERT INTO medico (codigo, nome, especialidade)
VALUES             (3, 'Carolina Oliveira', 'Ortopedista')

INSERT INTO medico (codigo, nome, especialidade)
VALUES             (4, 'Vinicius Araujo', 'Clinico Geral')

--Dados prontuario
INSERT INTO prontuario (data, CPF_paciente, codigo_medico, diagnostico, medicamento) 
VALUES              ('2020-09-10', '35454562890', 2, 'Reumatismo', 'Celebra')

INSERT INTO prontuario (data, CPF_paciente, codigo_medico, diagnostico, medicamento) 
VALUES				('2020-09-10', '92173458910', 2, 'Renite Al�rgica', 'Allegra')

INSERT INTO prontuario (data, CPF_paciente, codigo_medico, diagnostico, medicamento) 
VALUES				('2020-09-12', '29865439810', 1, 'Inflama��o de garganta', 'Nimesulina')

INSERT INTO prontuario (data, CPF_paciente, codigo_medico, diagnostico, medicamento) 
VALUES				('2020-09-13', '35454562890', 2, 'H1N1', 'Tamiflu')

INSERT INTO prontuario (data, CPF_paciente, codigo_medico, diagnostico, medicamento) 
VALUES				('2020-09-15', '82176534800', 4, 'Gripe', 'Resprin')

INSERT INTO prontuario (data, CPF_paciente, codigo_medico, diagnostico, medicamento) 
VALUES				('2020-09-15', '12386758770', 3, 'Bra�o Quebrado',	'Dorflex + Gesso')
			
SELECT * FROM paciente
SELECT * FROM prontuario 
SELECT * FROM medico

--Consultar:
--Nome e Endere�o (concatenado) dos pacientes com mais de 50 anos
SELECT nome, 
       rua + ', ' + CAST(N� AS varchar(5)) +', ' + bairro AS endereco_conct
FROM paciente
WHERE DATEDIFF(YEAR,  data_Nasc, GETDATE()) > 50

--Qual a especialidade de Carolina Oliveira
SELECT especialidade
FROM medico
WHERE nome LIKE 'Carolina%' 

--Qual medicamento receitado para reumatismo
SELECT medicamento
FROM prontuario
WHERE diagnostico LIKE '%eumati%'

--Diagn�stico e Medicamento do paciente Jos� Rubens em suas consultas
SELECT diagnostico, medicamento 
FROM prontuario
WHERE CPF_paciente IN 
(
   SELECT CPF
   FROM paciente 
   WHERE nome = 'Jos� Rubens'           
)

--Nome e especialidade do(s) M�dico(s) que atenderam Jos� Rubens. Caso a especialidade tenha mais de 3 letras, mostrar apenas as 3 primeiras letras concatenada com um ponto final (.)
SELECT nome, 
	   SUBSTRING(especialidade, 1, 3) + '.' AS especialidade
FROM medico
WHERE codigo IN
(
  SELECT codigo_medico
  FROM prontuario 
  WHERE CPF_paciente IN
  (
    SELECT CPF 
	FROM paciente
	WHERE nome = 'Jos� Rubens'
  ) 
)

--CPF (Com a m�scara XXX.XXX.XXX-XX), Nome, Endere�o completo (Rua, n� - Bairro), Telefone (Caso nulo, mostrar um tra�o (-)) dos pacientes do m�dico Vinicius
SELECT SUBSTRING(CPF, 1, 3) + '.' + SUBSTRING(CPF, 4, 3 ) + '.' + SUBSTRING(CPF, 7, 3) + '-' + SUBSTRING(CPF, 10, 2) AS CPF,
       nome,
	   rua +', ' + CAST(N� AS VARCHAR(5)) + ', ' + bairro AS Endere�o_completo,
	   CASE WHEN telefone IS NULL
	   THEN   '       -'
	   ELSE telefone
	   END AS telefone
FROM paciente
WHERE CPF IN 
(
  SELECT CPF_paciente 
  FROM prontuario
  WHERE codigo_medico IN 
  (
    SELECT codigo
	FROM medico 
	WHERE nome LIKE 'Vinicius%'
  )   
)

--Quantos dias fazem da consulta de Maria Rita at� hoje
SELECT DATEDIFF(DAY, data, GETDATE()) AS dias_desde_consulta
FROM prontuario
WHERE CPF_paciente IN 
(
  SELECT CPF
  FROM paciente
  WHERE nome = 'Maria Rita'
)

--Alterar o telefone da paciente Maria Rita, para 98345621
UPDATE paciente
SET telefone = '98345621'
WHERE nome = 'Maria Rita'

--Alterar o Endere�o de Joana de Souza para Volunt�rios da P�tria, 1980, Jd. Aeroporto
UPDATE paciente
SET rua = 'Voluntarios da Patria',
    N� = 1980,
	bairro = 'Jd. Aeroporto' 
WHERE nome = 'Joana de Souza'





