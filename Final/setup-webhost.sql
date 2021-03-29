-- [Problem 3]

DROP TABLE IF EXISTS installed_tracks, package_uses;
DROP TABLE IF EXISTS basic_acc, shared_acc;
DROP TABLE IF EXISTS dedi_server, shared_server;
DROP TABLE IF EXISTS accounts, servers, packages;

-- The table 'accounts' represents information with regards to users.
-- The attributers consist of username, email_add, website_url, open_time
-- (timestamp that the customer opened), sub_price (monthly subcription price)
-- and account type, which is either basic or preferred. 

CREATE TABLE accounts(
    username  VARCHAR(20)  PRIMARY KEY,
    email_add  VARCHAR(69)  NOT NULL,
    website_url  VARCHAR(200)  NOT NULL UNIQUE,
    open_time  TIMESTAMP  NOT NULL,
    sub_price  NUMERIC(8, 2)  NOT NULL,
    acc_type  CHAR(1)  NOT NULL
    
    -- Check if the acc_type is either basic or preferred.
    -- Note that B and P stands for basic and preferred, respectively. 
    
    CHECK(acc_type IN ('B', 'P'))
    
);


-- The table 'servers' represents information with regards to servers.
-- The attributers consist of hostname, os_type (operating-system type), 
-- max_sites (maximum number of sites that can be hosted on the machine)
-- server_type, which can be either shared or dedicated.

CREATE TABLE servers(
    hostname  VARCHAR(40)  PRIMARY KEY,
    os_type  VARCHAR(69)  NOT NULL,
    max_sites  INT  NOT NULL,
    server_type  CHAR(1)  NOT NULL
    
    -- Check if the server_type is either shared or dedicated.
    -- Note that S and D stands for shared and dedicated, respectively. 
    
    CHECK(server_type IN('S', 'D'))

);

-- The table 'packages' represents information with regards to packages.
-- The attributers consist of pack_name (package name), version, 
-- descriptionm, pack_price (monthly price that customers must pay for
-- using the software package. Note that the combination of package name
-- and version must be unique, so we put it in tuple of primary key.

CREATE TABLE packages(
    pack_name  VARCHAR(40),
    version  VARCHAR(20),
    description  VARCHAR(1000)  NOT NULL,
    pack_price  NUMERIC(8, 2)  NOT NULL,
    PRIMARY KEY (pack_name, version)
);


-- This table is a deidcated server.
CREATE TABLE dedi_server(
    hostname  VARCHAR(40)  PRIMARY KEY,
    
    FOREIGN KEY (hostname) REFERENCES servers(hostname)
);

-- This table is a shared server.
CREATE TABLE shared_server(
    hostname  VARCHAR(40)  PRIMARY KEY,
    
    FOREIGN KEY (hostname) REFERENCES servers(hostname)
);

-- This table is a basic account. 
CREATE TABLE basic_acc(
    username  VARCHAR(20)  PRIMARY KEY,
    hostname  VARCHAR(40)  NOT NULL,
    
    FOREIGN KEY (username) REFERENCES accounts(username),
    FOREIGN KEY (hostname) REFERENCES servers(hostname)
);

-- This table is a preferred account. 
-- Note taht hostname is a candidate day. 
CREATE TABLE pref_acc(
    username  VARCHAR(20)  PRIMARY KEY,
    hostname  VARCHAR(40)  NOT NULL UNIQUE,
    
    FOREIGN KEY (username) REFERENCES accounts(username),
    FOREIGN KEY (hostname) REFERENCES servers(hostname)
    
);


-- This table is a relationship set between servers where
-- package is installed on and packages.

CREATE TABLE installed_tracks(
    pack_name  VARCHAR(40),
    version  VARCHAR(20),
    hostname  VARCHAR(40),
    
    PRIMARY KEY (pack_name, version, hostname),
    
    FOREIGN KEY (pack_name, version) REFERENCES packages(pack_name, version),
    FOREIGN KEY (hostname) REFERENCES servers(hostname)
    
);

-- This table is a relationship set between customers and server that account
-- is associated with. 

CREATE TABLE package_uses(
    username  VARCHAR(20),
    pack_name  VARCHAR(40),
    version  VARCHAR(20),
    
    PRIMARY KEY (username, pack_name, version), 

    FOREIGN KEY (username) REFERENCES accounts(username),
    FOREIGN KEY (pack_name, version) REFERENCES packages(pack_name, version)
    
);





