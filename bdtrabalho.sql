CREATE TABLE Pessoa (
    cpf VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    sexo CHAR(1) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cep VARCHAR(8) NOT NULL,
    rua VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado CHAR(2) NOT NULL,
    
    CONSTRAINT chk_pessoa_cpf CHECK (cpf REGEXP '^[0-9]{11}$'),
    CONSTRAINT chk_pessoa_sexo CHECK (sexo IN ('M', 'F', 'm', 'f'))
);

CREATE TABLE Departamento (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE Turma (
    id_turma INT PRIMARY KEY AUTO_INCREMENT,
    nome_turma VARCHAR(50) NOT NULL,
    ano_escolar INT NOT NULL,
    turno VARCHAR(20) NOT NULL
);

CREATE TABLE Avaliacao (
    id_avaliacao INT PRIMARY KEY AUTO_INCREMENT,
    peso DECIMAL(4,2) NOT NULL,
    bimestre INT NOT NULL,
    data_avaliacao DATE NOT NULL,
    tipo_avaliacao VARCHAR(50) NOT NULL
);

CREATE TABLE Responsavel (
    cpf_responsavel VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    
    CONSTRAINT chk_resp_cpf CHECK (cpf_responsavel REGEXP '^[0-9]{11}$')
);

CREATE TABLE Aluno (
    cpf VARCHAR(11) PRIMARY KEY,
    matricula VARCHAR(20) UNIQUE NOT NULL,
    data_de_ingresso DATE NOT NULL,
    cpf_representante VARCHAR(11),
    
    CONSTRAINT fk_aluno_pessoa FOREIGN KEY (cpf) 
        REFERENCES Pessoa (cpf),

    CONSTRAINT fk_aluno_representante FOREIGN KEY (cpf_representante) 
        REFERENCES Aluno (cpf)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Professor (
    cpf VARCHAR(11) PRIMARY KEY,
    data_contratacao DATE NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    especialidade VARCHAR(100) NOT NULL,
    formacao VARCHAR(100) NOT NULL,
    
    CONSTRAINT fk_prof_pessoa FOREIGN KEY (cpf) 
        REFERENCES Pessoa (cpf)
);

CREATE TABLE Telefone (
    cpf_responsavel VARCHAR(11),
    telefone VARCHAR(15),
    
    PRIMARY KEY (cpf_responsavel, telefone),
    CONSTRAINT fk_tel_resp FOREIGN KEY (cpf_responsavel) 
        REFERENCES Responsavel (cpf_responsavel) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE Tutela (
    cpf_aluno VARCHAR(11),
    cpf_responsavel VARCHAR(11),
    
    PRIMARY KEY (cpf_aluno, cpf_responsavel),
    CONSTRAINT fk_tutela_aluno FOREIGN KEY (cpf_aluno) 
        REFERENCES Aluno (cpf),
    CONSTRAINT fk_tutela_resp FOREIGN KEY (cpf_responsavel) 
        REFERENCES Responsavel (cpf_responsavel)
);

CREATE TABLE Disciplina (
    id_disciplina INT AUTO_INCREMENT,
    id_turma INT,
    nome VARCHAR(100) NOT NULL DEFAULT 'Sem descrição',
    descricao VARCHAR(1000) NOT NULL,
    id_departamento INT,
    
    PRIMARY KEY (id_disciplina, id_turma),
    INDEX idx_id_disciplina (id_disciplina),

    CONSTRAINT fk_disc_turma FOREIGN KEY (id_turma) 
        REFERENCES Turma (id_turma),

    CONSTRAINT fk_disc_depto FOREIGN KEY (id_departamento) 
        REFERENCES Departamento (id_departamento)
);

CREATE TABLE Leciona (
    cpf_professor VARCHAR(11),
    id_disciplina INT,
    id_turma INT,
    
    PRIMARY KEY (cpf_professor, id_disciplina, id_turma),

    CONSTRAINT fk_leciona_prof FOREIGN KEY (cpf_professor) 
        REFERENCES Professor (cpf),

    CONSTRAINT fk_leciona_disc FOREIGN KEY (id_disciplina, id_turma) 
        REFERENCES Disciplina (id_disciplina, id_turma)
);

CREATE TABLE Cursa (
    cpf_aluno VARCHAR(11),
    id_disciplina INT,
    id_turma INT, 
    ano INT,
    
    PRIMARY KEY (cpf_aluno, id_disciplina, id_turma, ano),

    CONSTRAINT fk_cursa_aluno FOREIGN KEY (cpf_aluno) 
        REFERENCES Aluno (cpf),

    CONSTRAINT fk_cursa_disc FOREIGN KEY (id_disciplina, id_turma)
        REFERENCES Disciplina (id_disciplina, id_turma)
);

CREATE TABLE Realiza (
    cpf_aluno VARCHAR(11),
    id_disciplina INT,
    id_turma INT,
    id_avaliacao INT,
    ano INT,
    nota DECIMAL(5,2) NOT NULL,
    
    PRIMARY KEY (cpf_aluno, id_disciplina, id_turma, id_avaliacao, ano),

    CONSTRAINT fk_realiza_cursa FOREIGN KEY (cpf_aluno, id_disciplina, id_turma, ano)
        REFERENCES Cursa (cpf_aluno, id_disciplina, id_turma, ano)
        ON DELETE CASCADE,

    CONSTRAINT fk_realiza_aval FOREIGN KEY (id_avaliacao) 
        REFERENCES Avaliacao (id_avaliacao)
        ON DELETE CASCADE
);


