create database if not exists diamonds;
use diamonds; 

select color from diamonds;

-- COLOR TABLE ----------
-- create a new dimension table for the color dimension
create table if not exists diamonds.color (
color_id int auto_increment,
color  char,
primary key (color_id));

-- check the table was created...
select * from color;

-- lets populate the table by inserting the unique values for that dimension
insert into diamonds.color(color)
select distinct color from diamonds;

-- now lets adjust the original table so we will use this table
alter table main add column color_id int after color;
-- lets set up the foreign key reference
alter table main ADD CONSTRAINT color_fk FOREIGN KEY (color_id) REFERENCES color (color_id);

-- populate the column using the dimension table we created
SET SQL_SAFE_UPDATES = 0;
update main, color
set main.color_id = color.color_id
where main.color = color.color;

-- lets drop the original column now
alter table main drop column color;

select  DISTINCT carat, count(*) from main group by carat;
select * from main;

-- CUT TABLE -------------
create table if not exists cut_quality (
cut_id int auto_increment,
cut_desc  LONGTEXT,
primary key (cut_id));

select * from cut_quality;
-- lets populate the table by inserting the unique values for that dimension
insert into diamonds.cut_quality(cut_desc)
select distinct cut  from main order by cut desc;
select * from cut_quality;

-- now lets adjust the original table so we will use this table
alter table main add column cut_id int after cut;
-- lets set up the foreign key reference
alter table main ADD CONSTRAINT cut_fk FOREIGN KEY (cut_id) REFERENCES cut_quality (cut_id);
-- populate the column using the dimension table we created
update main, cut_quality
set main.cut_id = cut_quality.cut_id
where main.cut = cut_quality.cut_desc;
-- lets drop the original column now
alter table main drop column cut;
select  DISTINCT cut_id, count(*) from main group by cut_id;
select * from main;


-- CLARITY TABLE ----------------------
create table if not exists clarity_desc (
clarity_id int auto_increment,
clarity_code  LONGTEXT,
primary key (clarity_id));

select * from cut_quality;
-- lets populate the table by inserting the unique values for that dimension
insert into clarity_desc(clarity_code)
select distinct clarity  from main order by clarity desc;
select * from clarity_desc;

-- now lets adjust the original table so we will use this table
alter table main add column clarity_id int after clarity;
-- lets set up the foreign key reference
alter table main ADD CONSTRAINT clarity_fk FOREIGN KEY (clarity_id) REFERENCES clarity_desc (clarity_id);
-- populate the column using the dimension table we created
update main, clarity_desc
set main.clarity_id = clarity_desc.clarity_id
where main.clarity = clarity_desc.clarity_code;
-- lets drop the original column now
alter table main drop column clarity;
select  DISTINCT clarity_id, count(*) from main group by clarity_id;
select * from main;