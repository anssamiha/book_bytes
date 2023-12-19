
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_password`, `user_datereg`) VALUES
(3, 'slumberjer@gmail.com', 'Hanis', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', '2023-11-15 12:06:53.765976'),
(7, 'halim@email.com', 'Halim', 'bec75d2e4e2acf4f4ab038144c0d862505e52d07', '2023-11-15 12:17:15.964762');


ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);


ALTER TABLE `tbl_users`
    MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;
COMMIT;