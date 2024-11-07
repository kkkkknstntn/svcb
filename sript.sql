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

