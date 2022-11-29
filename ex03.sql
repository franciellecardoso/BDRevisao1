CREATE DATABASE ex03

GO 
use ex03

GO
CREATE TABLE paciente(
CPF                VARCHAR(11)           NOT NULL,
nome               VARCHAR(30)           NOT NULL,
Rua                VARCHAR(30)           NOT NULL,
Nº                 INT                   NOT NULL,
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
             ('35454562890', 'José Rubens', 'Campos Salles', 2750, 'Centro', '21450998', '1954-10-18'),
			 ('29865439810', 'Ana Claudia', 'Sete de Setembro', 178, 'Centro', '97382764', '1960-05-29'),
			 ('82176534800', 'Marcos Aurélio', 'Timóteo Penteado', 236, 'Vila Galvão', '68172651', '1980-09-24'),
			 ('12386758770', 'Maria Rita', 'Castello Branco', 7765, 'Vila Rosália', NULL, '1975-03-30'),
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
VALUES				('2020-09-10', '92173458910', 2, 'Renite Alérgica', 'Allegra')

INSERT INTO prontuario (data, CPF_paciente, codigo_medico, diagnostico, medicamento) 
VALUES				('2020-09-12', '29865439810', 1, 'Inflamação de garganta', 'Nimesulina')

INSERT INTO prontuario (data, CPF_paciente, codigo_medico, diagnostico, medicamento) 
VALUES				('2020-09-13', '35454562890', 2, 'H1N1', 'Tamiflu')

INSERT INTO prontuario (data, CPF_paciente, codigo_medico, diagnostico, medicamento) 
VALUES				('2020-09-15', '82176534800', 4, 'Gripe', 'Resprin')

INSERT INTO prontuario (data, CPF_paciente, codigo_medico, diagnostico, medicamento) 
VALUES				('2020-09-15', '12386758770', 3, 'Braço Quebrado',	'Dorflex + Gesso')
			
SELECT * FROM paciente
SELECT * FROM prontuario 
SELECT * FROM medico

--Consultar:
--Nome e Endereço (concatenado) dos pacientes com mais de 50 anos
SELECT nome, 
       rua + ', ' + CAST(Nº AS varchar(5)) +', ' + bairro AS endereco_conct
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

--Diagnóstico e Medicamento do paciente José Rubens em suas consultas
SELECT diagnostico, medicamento 
FROM prontuario
WHERE CPF_paciente IN 
(
   SELECT CPF
   FROM paciente 
   WHERE nome = 'José Rubens'           
)

--Nome e especialidade do(s) Médico(s) que atenderam José Rubens. Caso a especialidade tenha mais de 3 letras, mostrar apenas as 3 primeiras letras concatenada com um ponto final (.)
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
	WHERE nome = 'José Rubens'
  ) 
)

--CPF (Com a máscara XXX.XXX.XXX-XX), Nome, Endereço completo (Rua, nº - Bairro), Telefone (Caso nulo, mostrar um traço (-)) dos pacientes do médico Vinicius
SELECT SUBSTRING(CPF, 1, 3) + '.' + SUBSTRING(CPF, 4, 3 ) + '.' + SUBSTRING(CPF, 7, 3) + '-' + SUBSTRING(CPF, 10, 2) AS CPF,
       nome,
	   rua +', ' + CAST(Nº AS VARCHAR(5)) + ', ' + bairro AS Endereço_completo,
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

--Quantos dias fazem da consulta de Maria Rita até hoje
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

--Alterar o Endereço de Joana de Souza para Voluntários da Pátria, 1980, Jd. Aeroporto
UPDATE paciente
SET rua = 'Voluntarios da Patria',
    Nº = 1980,
	bairro = 'Jd. Aeroporto' 
WHERE nome = 'Joana de Souza'





