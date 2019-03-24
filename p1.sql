

CREATE TABLE user
(
  username VARCHAR(255) PRIMARY KEY,
  display_name VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255)NOT NULL
);

CREATE TABLE tweet 
(
  tweet_id INT PRIMARY KEY,
  content VARCHAR(140) NOT NULL,
  is_draft BOOLEAN NOT NULL DEFAULT true,
  username VARCHAR(255) NOT NULL REFERENCES user(username)
);

CREATE TABLE post
(   
   post_time TIMESTAMP(4) NOT NULL,
   username VARCHAR(255) NOT NULL REFERENCES user(username) PRIMARY KEY
);


CREATE TABLE follow 
(
	followee VARCHAR(255) NOT NULL REFERENCES user(username),
	follower VARCHAR(255) NOT NULL REFERENCES user(username),
	PRIMARY KEY (followee,follower)
);

CREATE TABLE likes 
(
	tweet_id INT NOT NULL REFERENCES tweet(tweet_id),
	number_likes INT NOT NULL,
	username VARCHAR(255) NOT NULL REFERENCES user(username)
	PRIMARY KEY ( username,tweet_id)
);

CREATE TABLE comment 
(
	username VARCHAR(255) NOT NULL REFERENCES user(username),
	tweet_id INT NOT NULL REFERENCES tweet(tweet_id),
	-- 65,535 characters
	content TEXT NOT NULL, 
	comment_time TIMESTAMP(6) NOT NULL
	number_comment INT
	PRIMARY KEY (username, tweet_id)
);

CREATE TABLE retweet 
(
	retweet_id INT PRIMARY KEY,
	username VARCHAR(255) NOT NULL REFERENCES user(username),
	tweet_id INT NOT NULL REFERENCES tweet(tweet_id),
	-- 65,535 characters
	comment TEXT NOT NULL,
	retweet_time TIMESTAMP(4) NOT NULL
	PRIMARY KEY (username,tweet_id)
);

