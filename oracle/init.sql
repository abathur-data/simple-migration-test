WHENEVER SQLERROR EXIT SQL.SQLCODE

CREATE TABLE customers (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

INSERT INTO customers (id, name, updated_at) VALUES (1, 'Alice', SYSTIMESTAMP);
INSERT INTO customers (id, name, updated_at) VALUES (2, 'Bob', SYSTIMESTAMP);
INSERT INTO customers (id, name, updated_at) VALUES (3, 'Charlie', SYSTIMESTAMP);
COMMIT;
EXIT;
