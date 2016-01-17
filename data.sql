-- Override the "default" users table seed
TRUNCATE TABLE `user`;

-- Every password is "vagrant".
INSERT INTO user (username, email, password, status, onwikiname, checkuser, emailsig) VALUES ('Admin',
'admin@localhost', ':2:x:$2y$10$FMnMGBrMxq0t8cZyt1W19uWtvgz/RhE97P2S6GJQqL3FCXuQR6g62', 'Admin', 'Admin', '1', '');
INSERT INTO user (username, email, password, status, onwikiname, checkuser, emailsig) VALUES ('AdminNoCU',
'adminnocu@localhost', ':2:x:$2y$10$xakiGCcCO650y6Ol5WRly.h37YapozGFjf8yLtTs62UBJ7l0D39zG', 'Admin', 'AdminNoCU', '0','');
INSERT INTO user (username, email, password, status, onwikiname, checkuser, emailsig) VALUES ('CheckUser',
'checkuser@localhost', ':2:x:$2y$10$tbsxnW6BihFA08detKhTDe4BCf5g81uIlmSxxT7Scl3uRLjB/EO3G', 'User', 'CheckUser', '1', '');
INSERT INTO user (username, email, password, status, onwikiname, checkuser, emailsig) VALUES ('User',
'user@localhost', ':2:x:$2y$10$yPcHbYPigFRWjruyvWX3n.xGv7HRSaO1bNlfBivGCNvVCE0qy4QfO', 'User', 'User', '0', '');
INSERT INTO user (username, email, password, status, onwikiname, checkuser, emailsig) VALUES ('New',
'new@localhost', ':2:x:$2y$10$vuRsKxkp3OjO9e8EbSv9.uKk8RVvjSQluOKh6LlMizJ76v7nhw6OW', 'New', 'New', '0', '');

UPDATE interfacemessage SET content = '<ul>\r\n<li>Remember that this is only a sandbox. <b>Do not</b> create any accounts here.</li>\r\n<li>Testing woo!</li>\r\n</ul>' WHERE id = 31;
