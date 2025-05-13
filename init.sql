USE nodedb;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  main VARCHAR(255),
  sub VARCHAR(255),
  json VARCHAR(2047),
  imageUrl VARCHAR(511)
);

INSERT INTO users (username, password) VALUES ('admin', 'admin123');
