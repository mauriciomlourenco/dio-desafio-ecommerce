create database oficina_mecanica;

use oficina_mecanica;

create table cliente_pj(
	idCliente int not null auto_increment,
	razao_social varchar(50) not null,
	nome_fantasia varchar(50) not null,
	cnpj char(15) not null,
	responsavel varchar(45), not null,
	data_cadastro date not null,
	telefone varchar(11) not null,
	email varchar(50) not null,
	endereco varchar (250) not null,
	constraint pk_cliente_cnpj primary key(idCliente),
	constraint unique_cliente_pj unique(cnpj)
);

create table cliente_pf(
	idCliente int not null auto_increment,
	nome varchar(50) not null,
	cpf char(11) not null
	data_nasc date not null,
	data_cadastro date not null,
	telefone varchar(11) not null,
	email varchar(50) not null,
	endereco varchar(250) not null,
	constraint pk_cliente_pf primary key (idCliente),
	constraint unique_cliente_pf unique(cpf)
);

create table servico (
	idServico int not null auto_increment,
	tipo enum('Manutenção', 'Revisão', 'Conserto') not null default 'Revisão',
	duracao float not null,
	valor float(9,2) not null
	constraint pk_servico primary key (idServico)
);

create table veiculo(
	idVeiculo int not null auto_increment,
	placa varchar(15) not null,
	marca varchar(30) not null,
	modelo varchar(30) not null,
	ano inti not null,
	km float(9,2) not null,
	fk_idCliente_PF int null,
	fk_idCliente_PJ int null,
	constraint pk_veiculo primary key(idVeiculo),
	constraint unique_placa_veiculo unique(placa),
	constraint fk_veiculo_cliente_pf foreign key (fk_idCliente_PF) references cliente_pf(idCliente),
	constraint fk_veiculo_cliente_pj foreign key (fk_idCliente_PJ) references cliente_pj(idCliente)
);

create table equipe(
	idEquipe int not null auto_increment,
	numFunc int not null,
	equipe varchar(50) not null,
	constraint pk_equipe primary key(idEquipe)
);

create table funcionario(
	idFunc int not null auto_increment,
	fk_idEquipe int not null,
	nome varchar(50) not null,
	cpf char(11) not null,
	data_nasc date not null,
	endereco varchar(250) not null,
	cargo varchar(45) not null,
	data_cantrato date not null,
	telefone varchar(15) not null,
	email varchar(100) not null,
	constraint pk_funcionario primary key(idFunc, fk_equipe),
	constraint fk_funcionario_equipe foreign key(fk_equipe) references equipe(idEquipe)
);

create table orcamento(
	idOrcamento int not null auto_increment,
	aprovado enum ('Sim', 'Não') not null defualt 'Não',
	valor float(9,2) not null,
	data date not null,
	fk_idVeiculo int not null,
	cod_funcionario int not null,
	contraint pk_orcament (idOrcamento, fk_idVeiculo),
	constraint fk_orcamneto_veiculo foreign key (fk_idVeiculo) references veiculo(idVeiculo)
);