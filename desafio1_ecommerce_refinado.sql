// Criação do banco de dados para o cenário de E-commerce

create database ecommerce;

use ecommerce;

-- criar tabela cliente

create table clients(
	idClient int auto_increment primary key,
	Fname varchar(10),
	Minit char(3),
	Lname varchar(20),
	Address varchar(255),
);

-- criar tabela para documentos dos clientes
create table client_type (
	id int not null auto_increment,
	Type enum('CPF', 'CNPJ'),
	doc_num varchar(15),
	fk_idClient int not null,
	constraint cliente_type_pk primary key (id, fk_idClient),
	constraint unique_cpf_cnpj unique(doc_num),
	constraint fk_clienteType_clients foreign key (fk_idCliente) references clients(idClient)
	
)

alter table clients auto_increment=1;
desc clients;

-- criar tabela produto
-- size = dimensão do produto
create table product(
	idProduct int auto_increment primary key,
	Pname varchar(255),
	classification_kids bool default false,
	category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
	avaliação float default 0,
	size varchar(10)
);

-- para ser continuado no desafio: termine de implementar a tabela e crie a conexão com as tabelas necessárias 
-- além disso reflita essas modificações no esquema relacional
-- criar constraints relacionadas ao pagamento
/*
create table payment(
	idClient int primary key,
	idPpayment int,
	typePayment enum('Boleto', 'Cartão', 'Dois Cartões'),
	limitAvailable float,
	primary key(idClient, idPayment)
);
*/

create table payment (
	idClient int primary key,
	idPpayment int,
	typePayment enum('Boleto', 'Cartão', 'Dois Cartões'),
	limitAvailable float,
	primary key(idClient, idPayment),
	constraint fk_payment_clients foreign key idClient references clients(idClient)
)

-- criar tabela pedido
create table orders (
	idOrder int auto_increment primary key,
	idOrderClient int,
	OrderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default "Em processamento",
	orderDescription varchar(255),
	sendValue float default 10,
	paymentCash bool default false,
	constraint fk_orders_client foreign key (idOrderClient) references  clients(idClient)
);

-- criar tabela estoque
create table productStorage (
	idProdStorage int auto_increment primary key,
	storageLocation varchar(255),
	quantity int default 0
);

-- criar fornecedor
create table supplier (
	idSupplier int auto_increment primary key,
	socialName varchar(225) not null,
	CNPJ char(15) not null,
	contact varchar(11) not null,
	constraint unique_supplier unique(CNPJ)
);


-- criar tabela vendedor
create table seller (
	idSeller int auto_increment primary key,
	socialName varchar(225) not null,
	AbstractName varchar(255),
	CNPJ char(15),
	CPF char(9),
	location varchar(255),
	contact char(11) not null,
	constraint unique_cnpj_seller unique(CNPJ),
	constraint unique_cpf_seller unique(CPF)
);


create table productSeller(
	idPSeller int,
	idPproduct int,
	prodQuantity int default 1,
	primary key (idPseller, idPproduct),
	constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
	constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

create table productOrder(
	idPOproduct int,
	idPOorder int,
	poQuantity int default 1,
	poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
	primary key (idPOproduct, idPOorder),
	constraint fk_productorder_seller foreign key (idPOorder) references product (idProduct),
	constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);

create table storageLocation(
	idLproduct int,
	idLstorage int,
	location varchar(255) not null,
	primary key (idLproduct, idLstorage),
	constraint fk_storage_location_seller foreign key (idLproduct) references product(idProduct),
	constraint fk_storage_location_product foreign key (idLstorage) references productStorage(idProdStorage)
);

create table productSupplier(
	idPsSupplier int,
	idPsProduct int,
	quantity int not null,
	primary key (idPsSupplier, idPsProduct),
	constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
	constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);

show tables;

show databases;

use information_schema;
show tables;

desc TABLE_CONSTRAINTS;
desc REFERENTIAL_CONSTRAINTS;

select * from REFERENTIAL_CONSTRAINTS where CONSTRAINT_SCHEMA = 'ecommerce';

-- persistindo e recuperando valores
-- idClient, Fname, Minit, Lname, CPF, Address
insert into clients (Fname, Minit, Lname, CPF, Address)
	values ('Maria', 'M', 'Silva', 'rua silva de prata 23, Carangola - Cidade das flores'),
		   ('Matheus', 'O', 'Pimentel', 'rua alameda 289, Centro - Cidade das flores'),
		   ('Ricardo', 'F', 'Silva', 'av alameda vinha 1009, Centro - Cidade das flores'),
		   ('Júlia', 'S', 'França', 'rua laranjeiras 861, Centro - Cidade das flores'),
		   ('Roberta', 'G', 'Assis', 'avenida koller 19, Centro - Cidade das flores'),
		   ('Isabela', 'M', 'Cruz', 'rua alameda das flores 28, Centro - Cidade das flores');

select * from clients;		  
		  
insert into product (Pname, classification_kids, category, avaliação, size) values
	('Fone de ouvido', false, 'Eletrônico', '4', null),
	('Barbie Elsa', true, 'Brinquedos', '3', null),
	('Body Carters', true, 'Vestimenta', '5', null),
	('Microfone Vedo - Youtuber', false, 'Eletrônico', '4', null),
	('Sofá retrátil', false, 'Móveis', '3', '3x57x80'),
	('Farinha de arroz', false, 'Alimentos', '2', null),
	('Fire Stick Amazon', false, 'Eletrônico', '3', null);
	
select * from product;

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
	(1, default, 'compra via aplicativo', null, 1),
	(2, default, 'compra via aplicativo', 50, 0),
	(3, 'Confirmado', null, null, 1),
	(4, default, 'compra via web site', 150, 0);
select * from orders;

insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
	(1,1,2,null),
	(2,1,2,null),
	(3,2,1,null);
	
insert into productStorage (storageLocation, quantity) values
	('Rio de Janeiro', 1000),
	('Rio de Janeiro', 500),
	('São Paulo', 10),
	('São Paulo', 100),
	('São Paulo', 10),
	('Brasília', 60);
	
insert into storageLocation (idLproduct, idLstorage, location) values
	(1,1,'RJ'),
	(2,6, 'GO');
	
insert into supplier (SocialName, CNPJ, contact) values
	('Almeida e filhos', 23456789123456, '21985474'),
	('Eletrônicos Silva',854519649143457, '21985484'),
	('Eletrônicos Valma',934567893934695, '21975474');
	
select * from supplier;

insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
			(1,1,500),
			(1,2,400),
			(2,4,633),
			(3,5,5),
			(2,5,10);
			
insert into seller (SocialName, AbstractName, CNPJ, CPF, location, contact) values
	('Tech eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219946287),
	('Boutique Durgas', null, null, 123456783 , 'Rio de Janeiro', 219567895),
	('Kids World', null, 456789123654485, null, 'São Paulo', 1198657484);
	
select * from seller;

insert into productSeller (idPseller, idPproduct, prodQuantity) values
		(1,6,80),
		(2,7,10);
		
select count(*) from clients;
select * from clients c, orders o where c.idClient = idOrderClient;

select Fname, Lname, idOrder, orderStatus from clients c, orders o where c.idClient  = idOrderClient;
select concat(Fname, ' ', Lname) as Client, idOrder as Request, orderStatus as OrderStatus from clients c, orders o where c.idClient  = idOrderClient;

select count(*) from clients c, orders o 
	where c.idClient = idOrderClient;

select * from clients left outer join orders on idClient = idOrderClient;

select * from productOrder;
select * from clients inner join orders on idClient = idOrderClient
					inner join productOrder on  idPOorder = idOrder;

-- recuperação de pedido com produto associado
				
select * from clients inner join orders on idClient = idOrderClient
					inner join productOrder on  idPOorder = idOrder
					group by idClient;

-- Recuperar quantos pedidos foram realizados pelos clientes
select idClient, Fname, count(*) as Number_of_orders from clients inner join orders on idClient = idOrderClient
					inner join productOrder on  idPOorder = idOrder
					group by idClient;
				
select idClient, Fname, count(*) as Number_of_orders from clients inner join orders on idClient = idOrderClient
					group by idClient;
