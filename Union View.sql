DROP DATABASE Faculdade
GO
CREATE DATABASE Faculdade
GO
USE Faculdade
GO
CREATE TABLE Curso (
Codigo_Curso	INT				NOT NULL,
Nome			VARCHAR(70)		NOT NULL,
Sigla			VARCHAR(10)		NOT NULL
PRIMARY KEY (Codigo_Curso)
)
GO
CREATE TABLE Palestrante (
Codigo_Palestrante	INT	IDENTITY	NOT NULL,
Nome				VARCHAR(250)	NOT NULL,
Empresa				VARCHAR(100)	NOT NULL
PRIMARY KEY (Codigo_Palestrante)
)
GO
CREATE TABLE Aluno (
RA				CHAR(7)			NOT NULL,
Nome			VARCHAR(250)	NOT NULL,
Codigo_Curso	INT				NOT NULL
PRIMARY KEY (RA)
FOREIGN KEY (Codigo_Curso) REFERENCES Curso (Codigo_Curso)
)
GO
CREATE TABLE nao_alunos(
    rg          VARCHAR(9)      NOT NULL,
    orgao_exp   CHAR(5)         NOT NULL,
    nome        VARCHAR(250)    NOT NULL,
    PRIMARY KEY (rg, orgao_exp)
)
GO
CREATE TABLE Palestra (
Codigo_Palestra		INT IDENTITY,
Titulo				VARCHAR(MAX)	NOT NULL,
Carga_Horaria		INT				NOT NULL,
Data_Palestra		DATETIME		NOT NULL,
Codigo_Palestrante	INT				NOT NULL
PRIMARY KEY (Codigo_Palestra)
FOREIGN KEY (Codigo_Palestrante) REFERENCES Palestrante (Codigo_Palestrante)
)
GO
CREATE TABLE Alunos_Inscritos(
RA					CHAR(7)			NOT NULL,
Codigo_Palestra		INT				NOT NULL
PRIMARY KEY (RA, Codigo_Palestra)
FOREIGN KEY (RA) REFERENCES Aluno (RA),
FOREIGN KEY (Codigo_Palestra) REFERENCES Palestra (Codigo_Palestra)
)
GO
CREATE TABLE nao_alunos_inscritos(
    codigo_palestra     INT             NOT NULL,
    rg                  VARCHAR(9)      NOT NULL,
    orgao_exp           CHAR(5)         NOT NULL,
    PRIMARY KEY (codigo_palestra, rg, orgao_exp),
    FOREIGN KEY (codigo_palestra)       REFERENCES Palestra (Codigo_Palestra),
    FOREIGN KEY (rg, orgao_exp)         REFERENCES nao_alunos(rg, orgao_exp)
)
GO

CREATE VIEW v_Presenca AS(
    SELECT p.Codigo_Palestra as Codigo, CAST(a.RA AS VARCHAR(15)) AS Num_Documento, a.Nome AS Nome_Pessoa, p.Titulo AS Titulo_Palestra, pa.Nome AS Nome_Palestrante, p.Carga_Horaria, p.Data_Palestra
	FROM Alunos_Inscritos ai INNER JOIN Aluno a
	ON ai.RA = a.RA
	INNER JOIN Palestra p
	ON p.Codigo_Palestra = ai.Codigo_Palestra
	INNER JOIN Palestrante pa
	ON p.Codigo_Palestrante = pa.Codigo_Palestrante

	UNION 

	SELECT p.Codigo_Palestra as Codigo,CAST(na.rg AS VARCHAR(9))+'-'+na.orgao_exp AS Num_Documento, na.nome AS Nome_Pessoa, p.Titulo AS Titulo_Palestra, pa.Nome AS Nome_Palestrante, p.Carga_Horaria, p.Data_Palestra
	FROM nao_alunos_inscritos nai INNER JOIN nao_alunos na
	ON na.rg = nai.rg AND na.orgao_exp = nai.orgao_exp
	INNER JOIN Palestra p
	ON p.Codigo_Palestra = nai.Codigo_Palestra
	INNER JOIN Palestrante pa
	ON p.Codigo_Palestrante = pa.Codigo_Palestrante
)
GO

SELECT Num_Documento, Nome_Pessoa, Titulo_Palestra, Nome_Palestrante, Carga_Horaria, Data_Palestra FROM v_Presenca 
WHERE Codigo = 5
ORDER BY Nome_Pessoa
