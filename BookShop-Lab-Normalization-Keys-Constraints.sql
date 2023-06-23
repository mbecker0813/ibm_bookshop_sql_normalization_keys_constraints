-- BOOKSHOP lab on Normalization, Keys, and Constraints
-- Drop the tables in case they exist

DROP TABLE BookShop;
DROP TABLE BookShop_AuthorDetails;

-- Create the table
-- Constraints are set after each column name - examples are VARCHAR(), INTEGER, DATE, NOT NULL, etc.

CREATE TABLE BookShop (
	BOOK_ID VARCHAR(4) NOT NULL, 
	TITLE VARCHAR(100) NOT NULL, 
	AUTHOR_NAME VARCHAR(30) NOT NULL, 
	AUTHOR_BIO VARCHAR(250),
	AUTHOR_ID INTEGER NOT NULL, 
	PUBLICATION_DATE DATE NOT NULL, 
	PRICE_USD DECIMAL(6,2) CHECK(Price_USD>0) NOT NULL
	);

-- Insert sample data into the table

INSERT INTO BookShop VALUES
('B101', 'Introduction to Algorithms', 'Thomas H. Cormen', 'Thomas H. Cormen is the co-author of Introduction to Algorithms, along with Charles Leiserson, Ron Rivest, and Cliff Stein. He is a Full Professor of computer science at Dartmouth College and currently Chair of the Dartmouth College Writing Program.', 123 , '2001-09-01', 125),
('B201', 'Structure and Interpretation of Computer Programs', 'Harold Abelson', 'Harold Abelson, Ph.D., is Class of 1922 Professor of Computer Science and Engineering in the Department of Electrical Engineering and Computer Science at MIT and a fellow of the IEEE.', 456, '1996-07-25', 65.5),
('B301', 'Deep Learning', 'Ian Goodfellow', 'Ian J. Goodfellow is a researcher working in machine learning, currently employed at Apple Inc. as its director of machine learning in the Special Projects Group. He was previously employed as a research scientist at Google Brain.', 369, '2016-11-01', 82.7),
('B401', 'Algorithms Unlocked', 'Thomas H. Cormen', 'Thomas H. Cormen is the co-author of Introduction to Algorithms, along with Charles Leiserson, Ron Rivest, and Cliff Stein. He is a Full Professor of computer science at Dartmouth College and currently Chair of the Dartmouth College Writing Program.', 123, '2013-05-15', 36.5),
('B501', 'Machine Learning: A Probabilistic Perspective', 'Kevin P. Murphy', '', 157, '2012-08-24', 46);

-- Retrieve all records from the table

SELECT * FROM BookShop;

-- Looking at the BookShop table, multiple books are written by the same author resulting in increased storage needed and
-- needing to update multiple occurrences should an author name need to be updated

-- Create a BookShop_AuthorDetails table by selecting the distinct occurrences of Author_ID, Author_Name, and Author_Bio from the BookShop table
CREATE TABLE BookShop_AuthorDetails 
AS 
(SELECT DISTINCT AUTHOR_ID, AUTHOR_NAME, AUTHOR_BIO FROM BookShop) 
WITH DATA;
SELECT * FROM BookShop_AuthorDetails;

-- Once we have the AuthorDetails table created, we can go back and alter the BookShop table by dropping the author columns
-- Don't drop the Author_ID column - that is our foreign key we will use to join the two tables together
-- 2nd Normal Form (2NF) is now ensured
ALTER TABLE BookShop
DROP COLUMN AUTHOR_NAME
DROP COLUMN AUTHOR_BIO;
SELECT * FROM BookShop;

-- After altering the table above, it is in a reorg pending state
-- Run a REORG operation to the table to put it back into an organized state
Call Sysproc.admin_cmd ('reorg Table BookShop');

-- Assign primary keys to the tables
ALTER TABLE BookShop
ADD PRIMARY KEY (BOOK_ID);
ALTER TABLE BookShop_AuthorDetails
ADD PRIMARY KEY (AUTHOR_ID);

-- Assign Author_ID as the foreign key in the BookShop table
ALTER TABLE BookShop
ADD CONSTRAINT fk_BookShop FOREIGN KEY (AUTHOR_ID)
    REFERENCES BookShop_AuthorDetails(AUTHOR_ID)
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
