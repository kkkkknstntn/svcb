-- Таблица пользователей
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    nickname VARCHAR(50) NOT NULL UNIQUE
);

-- Таблица статистики пользователей
CREATE TABLE statistics (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    game_count INT DEFAULT 0,
    win_count INT DEFAULT 0,
    word_count INT DEFAULT 0,
    points_record INT DEFAULT 0,
    points_word_record INT DEFAULT 0
);

-- Таблица состояний пользователей
CREATE TABLE states (
    id SERIAL PRIMARY KEY,
    user_hand JSONB NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Таблица слов
CREATE TABLE words (
    id SERIAL PRIMARY KEY,
    word VARCHAR(100) NOT NULL UNIQUE,
    meaning TEXT NOT NULL
);

-- Таблица лобби
CREATE TABLE lobbies (
    id SERIAL PRIMARY KEY,
    game_status VARCHAR(50) NOT NULL,
    privacy VARCHAR(20) NOT NULL, 
    private_key VARCHAR(50), 
    field JSONB NOT NULL 
);

-- Таблица статистики лобби пользователей
CREATE TABLE users_lobbies_statistics (
    id SERIAL PRIMARY KEY,
    points_number INT DEFAULT 0,
    is_winner BOOLEAN DEFAULT FALSE,
    words_count INT DEFAULT 0
);

-- Таблица лобби пользователей
CREATE TABLE user_lobbies (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    lobby_id INT REFERENCES lobbies(id) ON DELETE CASCADE,
    state_id INT REFERENCES states(id) ON DELETE SET NULL,
    user_lobby_statistic_id INT REFERENCES users_lobbies_statistics(id) ON DELETE SET NULL,
    is_creator BOOLEAN DEFAULT FALSE,
    turn_number INT DEFAULT 0
);

-- Таблица слов в лобби
CREATE TABLE words_lobbies (
    id SERIAL PRIMARY KEY,
    word_id INT REFERENCES words(id) ON DELETE CASCADE,
    lobby_id INT REFERENCES lobbies(id) ON DELETE CASCADE
);


INSERT INTO users (nickname) VALUES
('Player1'),
('Player2'),
('Player3'),
('Player4'),
('Player5'),
('Player6'),
('Player7'),
('Player8');

-- Заполнение таблицы statistics
INSERT INTO statistics (user_id, game_count, win_count, word_count, points_record, points_word_record) VALUES
(1, 10, 5, 50, 100, 20),
(2, 8, 4, 40, 80, 15),
(3, 15, 10, 60, 150, 30),
(4, 15, 6, 20, 51, 10),
(5, 6, 5, 54, 140, 23),
(6, 9, 3, 42, 60, 15),
(7, 15, 10, 69, 158, 34),
(8, 10, 2, 20, 50, 12);

-- Заполнение таблицы states
INSERT INTO states (user_hand, is_active) VALUES
('{"letters": ["А", "Б", "В", "Г", "Д", "Е", "Ж"]}', TRUE),
('{"letters": ["А", "Б", "В", "Г", "Д", "Е", "Ж"]}', FALSE),
('{"letters": ["А", "Б", "В", "Г", "Д", "Е", "Ж"]}', FALSE),
('{"letters": ["А", "Б", "В", "Г", "Д", "Е", "Ж"]}', FALSE),
('{"letters": ["А", "Б", "В", "Г", "Д", "Е", "Ж"]}', TRUE),
('{"letters": ["А", "Б", "В", "Г", "Д", "Е", "Ж"]}', FALSE),
('{"letters": ["А", "Б", "В", "Г", "Д", "Е", "Ж"]}', FALSE),
('{"letters": ["А", "Б", "В", "Г", "Д", "Е", "Ж"]}', FALSE),
('{"letters": ["А", "Б", "В", "Г", "Д", "Е", "Ж"]}', TRUE),
('{"letters": ["А", "Б", "В", "Г", "Д", "Е", "Ж"]}', FALSE),
('{"letters": ["А", "Б", "В", "Г", "Д", "Е", "Ж"]}', FALSE),
('{"letters": ["А", "Б", "В", "Г", "Д", "Е", "Ж"]}', FALSE);



-- Заполнение таблицы lobbies
INSERT INTO lobbies (game_status, privacy, private_key, field) VALUES
('in_progress', 'public', NULL, '{"grid": [[0,0],[0,0],[0,0]]}'),
('in_progress', 'private', 'secret123', '{"grid": [[1,1],[1,0],[0,0]]}'),
('finished', 'public', NULL, '{"grid": [[1,0],[0,1],[1,1]]}');

-- Заполнение таблицы words
INSERT INTO words (word, meaning) VALUES
('яблоко', 'Фрукт, который может быть красным или зеленым.'),
('банан', 'Длинный желтый фрукт.'),
('вишня', 'Маленький круглый фрукт, который бывает красным или черным.'),
('финик', 'Сладкий фрукт с пальмы финиковой.'),
('груша', 'Сладкий фрукт с характерной формой, обычно зеленого или желтого цвета.'),
('апельсин', 'Цитрусовый фрукт с ярко-оранжевой кожурой и сочной мякотью.'),
('киви', 'Маленький коричневый фрукт с зеленой мякотью и черными семенами.'),
('персик', 'Сладкий фрукт с мягкой кожурой и сочной мякотью, обычно оранжевого цвета.'),
('слива', 'Фрукт с гладкой кожурой, который может быть сладким или кислым.'),
('мандарин', 'Маленький цитрусовый фрукт с тонкой кожурой и сладкой мякотью.');

-- Заполнение таблицы users_lobbies_statistics
INSERT INTO users_lobbies_statistics (points_number, is_winner, words_count) VALUES
(10, NULL, 5),
(5, NULL, 3),
(15, NULL, 7),
(2, NULL, 1),
(10, NULL, 5),
(5, NULL, 3),
(15, NULL, 7),
(2, NULL, 1),
(100, TRUE, 5),
(5, FALSE, 3),
(15, FALSE, 7),
(2, FALSE, 1);

-- Заполнение таблицы user_lobbies
INSERT INTO user_lobbies (user_id, lobby_id, state_id, user_lobby_statistic_id, is_creator, turn_number) VALUES
(1, 1, 1, 1, TRUE, 1),
(2, 1, 2, 2, FALSE, 2),
(3, 1, 3 , 3 , TRUE , 3),
(4 ,1 ,4 ,3 ,FALSE , 4),
(5, 2, 5, 1, TRUE, 1),
(6, 2, 6, 2, FALSE, 2),
(7, 2, 7 , 3 , TRUE , 3),
(8 ,2 ,8 ,3 ,FALSE ,4),
(1, 3, 9, 1, TRUE, 1),
(4, 3, 10, 2, FALSE, 2),
(6, 3, 11, 3 , TRUE , 3),
(8 ,3 , 12, 3 ,FALSE ,4);


-- Заполнение таблицы words_lobbies
INSERT INTO words_lobbies (word_id , lobby_id ) VALUES
(1 ,1 ),
(2 ,1 ),
(3 ,2 ),
(4 ,3 ),
(5 ,1 ),
(6 ,1 ),
(7 ,2 ),
(8 ,3 ),
(9 ,1 ),
(10 ,2 );

