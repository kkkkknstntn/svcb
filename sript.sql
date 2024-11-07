--Запрос 1: Топ-5 пользователей по очкам за слово

SELECT user_id, points_word_record FROM statistics
ORDER BY points_word_record DESC LIMIT 5;

--Запрос 2: Игра публичная и еще не началась

SELECT * FROM lobbies
WHERE privacy = 'public' AND game_status = 'waiting';

--Запрос 3: Вывод пользователей, которые сыграли больше 20 игр и процент побед которых выше 90
SELECT users.nickname, statistics.game_count, statistics.win_count,
       (statistics.win_count::FLOAT / statistics.game_count) * 100 AS win_percentage
FROM users
JOIN statistics ON users.id = statistics.user_id
WHERE statistics.game_count > 20
  AND (statistics.win_count::FLOAT / statistics.game_count) * 100 > 90;

--Запрос 4: Вывод лобби "в ожидании", в которых 3/4 игроков уже присоединились

SELECT lobbies.id, lobbies.game_status, lobbies.privacy, COUNT(user_lobbies.user_id) AS player_count
FROM lobbies
JOIN user_lobbies ON lobbies.id = user_lobbies.lobby_id
GROUP BY lobbies.id
HAVING COUNT(user_lobbies.user_id) = 3;

--Запрос 5: Вывод пользователей, которые достигли рекорда (пример - 1000) очков за все игры

SELECT users.nickname, statistics.points_word_record
FROM users
JOIN statistics ON users.id = statistics.user_id
WHERE statistics.points_word_record >= 1000;

--Запрос 6: Топ-5 слов по частоте

SELECT w.word, 
       COUNT(wl.lobby_id) AS usage_count
FROM words w
JOIN words_lobbies wl ON w.id = wl.word_id
GROUP BY w.word
ORDER BY usage_count DESC
LIMIT 5;

--Запрос 7: Среднее количество очков за игру для каждого пользователя

SELECT u.nickname, 
       AVG(uls.points_number) AS average_points
FROM users u
JOIN user_lobbies ul ON u.id = ul.user_id
JOIN users_lobbies_statistics uls ON ul.user_lobby_statistic_id = uls.id
GROUP BY u.nickname;

--Запрос 8: Номер пользователя по никнейму в топе по количеству побед
SELECT *
FROM (
    SELECT u.nickname,
           ROW_NUMBER() OVER (ORDER BY s.win_count DESC) AS rank
    FROM users u
    JOIN statistics s ON u.id = s.user_id
) AS ranked_users
WHERE ranked_users.nickname = 'Player1';

--Запрос 9:  Номер пользователя по никнейму в топе по отношению побед к поражениям
SELECT *
FROM (
    SELECT u.nickname,
           ROW_NUMBER() OVER (ORDER BY (s.win_count * 1.0 / CASE WHEN (s.win_count - s.game_count) = 0 THEN 1 ELSE (s.win_count - s.game_count) END) DESC) AS rank
    FROM users u
    JOIN statistics s ON u.id = s.user_id
) AS ranked_users
WHERE ranked_users.nickname = 'Player1';

--Запрос 10: Наибольшее количество слов, использованных в одной игре

SELECT l.id AS lobby_id,
       COUNT(wl.word_id) AS words_used_count
FROM lobbies l
JOIN words_lobbies wl ON l.id = wl.lobby_id
GROUP BY l.id
ORDER BY words_used_count DESC 
LIMIT 1;