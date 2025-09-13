-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 13, 2025 at 02:09 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `acadify`
--

-- --------------------------------------------------------

--
-- Table structure for table `assignments`
--

CREATE TABLE `assignments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `due_date` date NOT NULL,
  `is_completed` tinyint(1) DEFAULT 0,
  `is_submitted` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assignments`
--

INSERT INTO `assignments` (`id`, `user_id`, `name`, `due_date`, `is_completed`, `is_submitted`) VALUES
(4, 22, 'OT', '2025-05-24', 1, 1),
(5, 22, 'RM', '2025-06-01', 1, 1),
(6, 22, 'Java', '2025-05-24', 1, 1),
(10, 22, 'AWD', '2025-05-15', 1, 1),
(11, 22, 'ML', '2025-05-30', 1, 1),
(13, 22, 'OT', '2025-05-25', 1, 1),
(22, 22, 'mAth', '2025-06-07', 1, 1),
(26, 24, 'Project Report ', '2025-05-25', 1, 1),
(27, 22, 'ML', '2025-05-25', 1, 1),
(28, 26, 'Study Python!!!!', '2025-05-26', 0, 0),
(29, 22, 'Aman NOOB', '2025-05-31', 1, 1),
(30, 22, 'Aman NOOB', '2025-05-31', 0, 0),
(31, 30, 'OT', '2025-08-02', 1, 1),
(32, 30, 'ML', '2025-08-02', 1, 1),
(33, 30, 'JAVA', '2025-08-02', 1, 1),
(34, 30, 'soem', '2025-08-02', 0, 0),
(35, 30, 'mmfcmcxccx', '2025-08-02', 0, 0),
(36, 32, 'OT', '2025-11-23', 1, 1),
(37, 32, 'Java', '2025-11-21', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `course_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `user_id`, `course_name`) VALUES
(1, 18, 'x'),
(2, 18, 'python'),
(3, 18, 'python'),
(4, 22, 'Python Programming'),
(5, 22, 'Programming with Java'),
(6, 24, 'Omniscient Prep'),
(7, 22, 'ML'),
(8, 26, 'python'),
(9, 22, 'Java Programming '),
(10, 27, 'Omniscient Prep'),
(11, 27, 'Aptitude'),
(12, 30, 'AWS'),
(13, 32, 'python ');

-- --------------------------------------------------------

--
-- Table structure for table `grades`
--

CREATE TABLE `grades` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `semester` int(11) DEFAULT NULL,
  `subject_name` varchar(100) DEFAULT NULL,
  `marks_obtained` double DEFAULT NULL,
  `marks_total` double DEFAULT NULL,
  `entry_type` varchar(10) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `total_marks` float DEFAULT NULL,
  `cgpa` float DEFAULT NULL
) ;

--
-- Dumping data for table `grades`
--

INSERT INTO `grades` (`id`, `user_id`, `semester`, `subject_name`, `marks_obtained`, `marks_total`, `entry_type`, `created_at`, `total_marks`, `cgpa`) VALUES
(37, 30, 1, NULL, 8.46, NULL, 'semester', '2025-08-04 18:34:25', NULL, 8.46),
(38, 30, 2, NULL, 8.31, NULL, 'semester', '2025-08-04 18:34:37', NULL, 8.31),
(39, 30, 3, NULL, 8.9, NULL, 'semester', '2025-08-04 18:34:49', NULL, 8.9),
(40, 30, 4, NULL, 9.2, NULL, 'semester', '2025-08-04 18:35:07', NULL, 9.2),
(41, 30, NULL, 'Java', 52, NULL, 'subject', '2025-08-04 18:35:32', 75, NULL),
(42, 30, NULL, 'STQA', 45, NULL, 'subject', '2025-08-04 18:35:57', 75, NULL),
(43, 30, NULL, 'OT', 46, NULL, 'subject', '2025-08-04 18:36:19', 75, NULL),
(44, 32, 1, NULL, 8.46, NULL, 'semester', '2025-08-10 13:25:55', NULL, 8.46),
(45, 32, 2, NULL, 8.31, NULL, 'semester', '2025-08-10 13:26:04', NULL, 8.31),
(46, 32, 3, NULL, 9.1, NULL, 'semester', '2025-08-10 13:26:18', NULL, 9.1);

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE `sections` (
  `id` int(11) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `section_name` varchar(255) DEFAULT NULL,
  `completed` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`id`, `course_id`, `section_name`, `completed`) VALUES
(1, 1, 'x', 0),
(2, 2, 'core concepts', 0),
(3, 3, 'core concepts', 0),
(4, 4, 'core concepts', 1),
(5, 4, 'Advanced Concepts', 1),
(6, 4, 'Frameworks', 1),
(7, 5, 'Core Java', 1),
(8, 5, 'Servlets', 0),
(9, 5, 'JSP', 0),
(10, 5, 'Spring Framework', 1),
(11, 5, 'SpringBoot', 1),
(12, 6, 'core java', 1),
(13, 6, 'Spring', 0),
(14, 7, 'Basic', 1),
(15, 7, 'advanced', 0),
(16, 8, '1', 0),
(17, 8, '2', 0),
(18, 8, '3', 1),
(19, 8, '4', 0),
(20, 8, '5', 0),
(21, 9, 'Core', 1),
(22, 9, 'Advanced', 0),
(23, 9, 'Spring', 0),
(24, 9, 'Servlet', 0),
(25, 10, 'Aptitude', 0),
(26, 10, 'Core java', 0),
(27, 10, 'GD', 0),
(28, 10, 'Advanced java', 0),
(29, 11, 'Percentage(25 questions)', 1),
(30, 11, 'Time, Speed & Distance', 0),
(31, 11, 'Profit and Loss', 0),
(32, 11, 'Number/Letter Series', 0),
(33, 11, 'Blood Relations', 0),
(34, 12, 'fundamentals', 1),
(35, 12, 'aws intro', 0),
(36, 13, 'core', 1),
(37, 13, 'advanced', 0),
(38, 13, 'sbjxkaz', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) DEFAULT NULL,
  `role` enum('student','admin') DEFAULT 'student',
  `verification_token` varchar(255) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `verification_token`, `is_verified`) VALUES
(18, 'x', 'x@gmail.com', '$2a$10$LMvwu9BMzp1aBhAy0JKkSOAB163.4dxZOcFuNCaRFDwuguMUmLlVi', 'student', NULL, 0),
(19, 'mahi', 'mahi@gmail.com', '$2a$10$862r4.4jEl5JsbpXT2rzC.4asN46oFqzPUKHW9uW0p0WspyELMJDW', 'student', NULL, 0),
(20, 'Admin', 'admin@gmail.com', 'admin', 'admin', NULL, 0),
(21, 'admin', 'admin@acadify.com', '$2a$12$N9qo8uLOickgx2ZMRZoMy.MFvU7M6YqN3N6Lp7yQ2RvD2ed5PbD7a', 'admin', NULL, 0),
(22, 'mahekv', 'mahekv17@gmail.com', '$2a$10$fVQy53ZrGBMA0zbB.jd6dOedOheVVha/oselpDo6K5nVP90mQ/UMi', 'student', NULL, 0),
(24, 'Anjali', 'anjalijaisinghani@gmail.com', '$2a$10$jM5vNafTZaYu/EwhHTZjcu/L5QCKCoBeiJAKoOIXUC8L/T/9xkr7m', 'student', NULL, 0),
(26, 'mayuri', 'mayuriwagh252@gmail.com', '$2a$10$KCFVwxIaUfdodnJVQAoXEeKchz/usHKNPzaH9tR.VHFOpgtV.BuR6', 'student', NULL, 0),
(27, 'Mahek', 'mahekvatyani17@gmail.com', '$2a$10$hksN77wGs1yYqRsMcs5ixOrbGksGzOwYXWRf32ar949Y6xo0iQ9OG', 'student', NULL, 1),
(30, 'jyoti', 'vatyanijyoti7@gmail.com', '$2a$10$.vJ6gBKTcPESn1I8Zf9l8.WjeNywUI1ha6o9HfNeTtFKRfLONTyhC', 'student', NULL, 1),
(31, 'Aman', 'aman08.stars@gmail.com', '$2a$10$osmjQtoHVnrz9UccI3QlE.scHNPAqyYqPj70GG.PsKwi7ZrgqgGEK', 'student', '848dcd26-f6da-41cc-9aa9-376cbf57619b', 0),
(32, 'chandani', 'tekwanichandani1@gmail.com', '$2a$10$5XMc.w64O8.36urpbytRveTWXaFNu5L2Co6ZIRxtOumHgLeQouDKe', 'student', NULL, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assignments`
--
ALTER TABLE `assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user` (`user_id`);

--
-- Indexes for table `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assignments`
--
ALTER TABLE `assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `grades`
--
ALTER TABLE `grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assignments`
--
ALTER TABLE `assignments`
  ADD CONSTRAINT `assignments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `grades`
--
ALTER TABLE `grades`
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `sections`
--
ALTER TABLE `sections`
  ADD CONSTRAINT `sections_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
