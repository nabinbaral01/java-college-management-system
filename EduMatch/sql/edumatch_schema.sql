-- ============================================================
-- EduMatch: College Discovery & Eligibility Platform
-- Database Schema - MySQL
-- Normalized to 3NF with full constraints
-- Created with UTF-8 support for Nepali language characters
-- ============================================================

CREATE DATABASE IF NOT EXISTS edumatch_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE edumatch_db;

-- ============================================================
-- TABLE: roles
-- ============================================================
CREATE TABLE roles (
    role_id   INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO roles (role_name) VALUES ('ADMIN'), ('STUDENT');

-- ============================================================
-- TABLE: users (base authentication table)
-- ============================================================
CREATE TABLE users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id       INT          NOT NULL,
    is_active     TINYINT(1)   DEFAULT 1,
    created_at    DATETIME     DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_role FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- ============================================================
-- TABLE: student_profiles
-- ============================================================
CREATE TABLE student_profiles (
    profile_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT          NOT NULL UNIQUE,
    full_name       VARCHAR(100) NOT NULL,
    date_of_birth   DATE,
    gender          ENUM('Male','Female','Other','Prefer not to say'),
    phone           VARCHAR(20),
    address         VARCHAR(255),
    district        VARCHAR(100),
    province        VARCHAR(100),
    citizenship_no  VARCHAR(50),
    profile_photo   VARCHAR(255),
    bio             TEXT,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_sp_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: academic_records
-- ============================================================
CREATE TABLE academic_records (
    record_id       INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT            NOT NULL,
    level           ENUM('SEE','+2','Bachelor') NOT NULL,
    board           VARCHAR(100),
    institution     VARCHAR(200),
    passed_year     YEAR,
    gpa             DECIMAL(4,2),
    percentage      DECIMAL(5,2),
    grade           VARCHAR(10),
    document_path   VARCHAR(255),
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ar_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT uq_record UNIQUE (user_id, level)
);

-- ============================================================
-- TABLE: provinces (Nepal)
-- ============================================================
CREATE TABLE provinces (
    province_id   INT AUTO_INCREMENT PRIMARY KEY,
    province_name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO provinces (province_name) VALUES
    ('Koshi Province'),('Madhesh Province'),('Bagmati Province'),
    ('Gandaki Province'),('Lumbini Province'),('Karnali Province'),('Sudurpashchim Province');

-- ============================================================
-- TABLE: districts
-- ============================================================
CREATE TABLE districts (
    district_id   INT AUTO_INCREMENT PRIMARY KEY,
    district_name VARCHAR(100) NOT NULL,
    province_id   INT NOT NULL,
    CONSTRAINT fk_dist_prov FOREIGN KEY (province_id) REFERENCES provinces(province_id)
);

INSERT INTO districts (district_name, province_id) VALUES
    ('Kathmandu',3),('Lalitpur',3),('Bhaktapur',3),('Chitwan',3),('Makwanpur',3),
    ('Pokhara',4),('Kaski',4),('Syangja',4),
    ('Jhapa',1),('Morang',1),('Sunsari',1),('Ilam',1),
    ('Bara',2),('Parsa',2),('Rautahat',2),('Sarlahi',2),
    ('Rupandehi',5),('Kapilvastu',5),('Palpa',5),
    ('Surkhet',6),('Dailekh',6),
    ('Kanchanpur',7),('Doti',7);

-- ============================================================
-- TABLE: faculties
-- ============================================================
CREATE TABLE faculties (
    faculty_id   INT AUTO_INCREMENT PRIMARY KEY,
    faculty_name VARCHAR(100) NOT NULL UNIQUE,
    description  TEXT,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO faculties (faculty_name, description) VALUES
    ('Science & Technology','Engineering, IT, Science programs'),
    ('Management','BBA, BBS, MBA programs'),
    ('Humanities & Social Sciences','Arts, Social Work, Education programs'),
    ('Medical & Health Sciences','MBBS, Nursing, Pharmacy programs'),
    ('Law','LLB, LLM programs'),
    ('Education','BEd, MEd programs'),
    ('Agriculture','Agriculture, Forestry programs'),
    ('Fine Arts','Music, Dance, Visual Arts programs');

-- ============================================================
-- TABLE: colleges
-- ============================================================
CREATE TABLE colleges (
    college_id        INT AUTO_INCREMENT PRIMARY KEY,
    college_name      VARCHAR(200) NOT NULL,
    short_name        VARCHAR(50),
    college_type      ENUM('Government','Private','Community','Constituent') NOT NULL,
    affiliation       VARCHAR(200),
    establishment_year YEAR,
    district_id       INT,
    address           VARCHAR(255),
    phone             VARCHAR(30),
    email             VARCHAR(100),
    website           VARCHAR(200),
    description       TEXT,
    logo_path         VARCHAR(255),
    banner_path       VARCHAR(255),
    is_active         TINYINT(1) DEFAULT 1,
    created_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_col_dist FOREIGN KEY (district_id) REFERENCES districts(district_id)
);

-- ============================================================
-- TABLE: programs (offered by colleges)
-- ============================================================
CREATE TABLE programs (
    program_id        INT AUTO_INCREMENT PRIMARY KEY,
    college_id        INT NOT NULL,
    faculty_id        INT NOT NULL,
    program_name      VARCHAR(200) NOT NULL,
    degree_level      ENUM('Certificate','Diploma','+2','Bachelor','Master','PhD') NOT NULL,
    duration_years    DECIMAL(3,1),
    total_seats       INT,
    annual_fee        DECIMAL(12,2),
    min_gpa           DECIMAL(4,2),
    min_percentage    DECIMAL(5,2),
    required_grade    VARCHAR(10),
    entrance_required TINYINT(1) DEFAULT 0,
    entrance_name     VARCHAR(100),
    description       TEXT,
    is_active         TINYINT(1) DEFAULT 1,
    created_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_prog_col  FOREIGN KEY (college_id) REFERENCES colleges(college_id) ON DELETE CASCADE,
    CONSTRAINT fk_prog_fac  FOREIGN KEY (faculty_id) REFERENCES faculties(faculty_id)
);

-- ============================================================
-- TABLE: facilities
-- ============================================================
CREATE TABLE facilities (
    facility_id   INT AUTO_INCREMENT PRIMARY KEY,
    facility_name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO facilities (facility_name) VALUES
    ('Library'),('Computer Lab'),('Hostel'),('Canteen'),('Sports Ground'),
    ('Wi-Fi Campus'),('Research Lab'),('Auditorium'),('Medical Facility'),
    ('Scholarship Available'),('Transportation'),('Parking');

-- ============================================================
-- TABLE: college_facilities (M:N)
-- ============================================================
CREATE TABLE college_facilities (
    college_id  INT NOT NULL,
    facility_id INT NOT NULL,
    PRIMARY KEY (college_id, facility_id),
    CONSTRAINT fk_cf_col FOREIGN KEY (college_id)  REFERENCES colleges(college_id)  ON DELETE CASCADE,
    CONSTRAINT fk_cf_fac FOREIGN KEY (facility_id) REFERENCES facilities(facility_id)
);

-- ============================================================
-- TABLE: applications
-- ============================================================
CREATE TABLE applications (
    application_id  INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    program_id      INT NOT NULL,
    status          ENUM('Draft','Submitted','Under Review','Shortlisted','Accepted','Rejected','Withdrawn') DEFAULT 'Draft',
    applied_date    DATETIME DEFAULT CURRENT_TIMESTAMP,
    remarks         TEXT,
    admin_notes     TEXT,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_app_user FOREIGN KEY (user_id)    REFERENCES users(user_id)    ON DELETE CASCADE,
    CONSTRAINT fk_app_prog FOREIGN KEY (program_id) REFERENCES programs(program_id),
    CONSTRAINT uq_application UNIQUE (user_id, program_id)
);

-- ============================================================
-- TABLE: saved_colleges (bookmarks)
-- ============================================================
CREATE TABLE saved_colleges (
    save_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    college_id INT NOT NULL,
    saved_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sc_user FOREIGN KEY (user_id)    REFERENCES users(user_id)    ON DELETE CASCADE,
    CONSTRAINT fk_sc_col  FOREIGN KEY (college_id) REFERENCES colleges(college_id) ON DELETE CASCADE,
    CONSTRAINT uq_saved   UNIQUE (user_id, college_id)
);

-- ============================================================
-- TABLE: notifications
-- ============================================================
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT,
    title           VARCHAR(200) NOT NULL,
    message         TEXT NOT NULL,
    type            ENUM('Info','Warning','Success','Danger') DEFAULT 'Info',
    is_read         TINYINT(1) DEFAULT 0,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: audit_logs
-- ============================================================
CREATE TABLE audit_logs (
    log_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT,
    action      VARCHAR(100) NOT NULL,
    entity      VARCHAR(100),
    entity_id   INT,
    description TEXT,
    ip_address  VARCHAR(50),
    logged_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_log_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- ============================================================
-- SEED DATA: Admin user (password: Admin@123 - BCrypt hashed)
-- ============================================================
INSERT INTO users (username, email, password_hash, role_id) VALUES
    ('admin', 'admin@edumatch.np', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TiGniMnQlNqptjJUMp1ySJBrwuCy', 1);

-- ============================================================
-- SEED DATA: Sample Colleges
-- ============================================================
INSERT INTO colleges (college_name, short_name, college_type, affiliation, establishment_year, district_id, address, phone, email, website, description) VALUES
('Tribhuvan University', 'TU', 'Government', 'Tribhuvan University', 1959, 1, 'Kirtipur, Kathmandu', '01-4331717', 'info@tu.edu.np', 'https://www.tribhuvan-university.edu.np', 'Nepal\'s oldest and largest university offering diverse programs across science, management, humanities, and more.'),
('Kathmandu University', 'KU', 'Private', 'Kathmandu University', 1991, 4, 'Dhulikhel, Kavre', '011-661399', 'info@ku.edu.np', 'https://www.ku.edu.np', 'A premier autonomous university emphasizing quality education in science, engineering, management, and arts.'),
('Pokhara University', 'PU', 'Government', 'Pokhara University', 1997, 6, 'Lekhnath, Kaski', '061-504015', 'info@pu.edu.np', 'https://www.pu.edu.np', 'A public university in the Gandaki region offering technical and professional programs.'),
('Purbanchal University', 'PurbU', 'Government', 'Purbanchal University', 1994, 9, 'Gothgaun, Morang', '021-540252', 'info@purbanchaluniversity.edu.np', 'https://www.purbanchaluniversity.edu.np', 'University serving eastern Nepal with diverse academic programs.'),
('Mid-Western University', 'MWU', 'Government', 'Mid-Western University', 2010, 20, 'Surkhet', '083-522422', 'info@mwu.edu.np', 'https://www.mwu.edu.np', 'Serving mid-western Nepal region with quality higher education.'),
('IOE Pulchowk Campus', 'IOE', 'Government', 'Tribhuvan University', 1942, 2, 'Pulchowk, Lalitpur', '01-5521311', 'info@ioe.edu.np', 'https://www.ioe.edu.np', 'Nepal\'s top engineering institute under TU offering BE and ME programs.'),
('CAAN Aviation Academy', 'CAANAA', 'Government', 'TU', 2010, 1, 'Sinamangal, Kathmandu', '01-4113267', 'info@caanaa.edu.np', 'https://www.caanaa.edu.np', 'Aviation-focused technical institute in Kathmandu.'),
('Nepal Medical College', 'NMC', 'Private', 'Kathmandu University', 1997, 1, 'Jorpati, Kathmandu', '01-4911008', 'info@nmc.edu.np', 'https://www.nmc.edu.np', 'Leading private medical college offering MBBS and BDS programs.');

-- Programs for Colleges
INSERT INTO programs (college_id, faculty_id, program_name, degree_level, duration_years, total_seats, annual_fee, min_percentage, entrance_required, entrance_name, description) VALUES
(1, 1, 'BSc CSIT', 'Bachelor', 4, 72, 45000, 45.00, 1, 'TU Entrance Exam', 'Bachelor of Science in Computer Science and Information Technology'),
(1, 2, 'BBS', 'Bachelor', 4, 100, 20000, 40.00, 0, NULL, 'Bachelor of Business Studies'),
(1, 3, 'BA', 'Bachelor', 4, 120, 15000, 35.00, 0, NULL, 'Bachelor of Arts in Humanities'),
(1, 6, 'BEd', 'Bachelor', 4, 80, 18000, 40.00, 0, NULL, 'Bachelor of Education'),
(2, 1, 'BE Computer', 'Bachelor', 4, 64, 350000, 60.00, 1, 'KU Entrance Exam', 'Bachelor of Engineering in Computer Engineering'),
(2, 2, 'BBA', 'Bachelor', 4, 60, 200000, 55.00, 1, 'KU Entrance Exam', 'Bachelor of Business Administration'),
(3, 1, 'BIT', 'Bachelor', 4, 60, 80000, 45.00, 1, 'PU Entrance', 'Bachelor of Information Technology'),
(3, 2, 'BBA', 'Bachelor', 4, 60, 90000, 45.00, 1, 'PU Entrance', 'Bachelor of Business Administration'),
(6, 1, 'BE Civil', 'Bachelor', 4, 96, 120000, 65.00, 1, 'IOE Entrance', 'Bachelor of Engineering in Civil Engineering'),
(6, 1, 'BE Electronics', 'Bachelor', 4, 64, 120000, 65.00, 1, 'IOE Entrance', 'Bachelor of Engineering in Electronics and Communication'),
(6, 1, 'BE Electrical', 'Bachelor', 4, 64, 120000, 60.00, 1, 'IOE Entrance', 'Bachelor of Engineering in Electrical Engineering'),
(8, 4, 'MBBS', 'Bachelor', 5, 100, 4500000, 70.00, 1, 'MECEE-BL', 'Bachelor of Medicine and Bachelor of Surgery'),
(8, 4, 'BDS', 'Bachelor', 5, 50, 3500000, 65.00, 1, 'MECEE-BL', 'Bachelor of Dental Surgery');

-- College Facilities
INSERT INTO college_facilities VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,10),
(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),(2,8),(2,10),(2,11),
(3,1),(3,2),(3,4),(3,5),(3,6),(3,10),
(6,1),(6,2),(6,3),(6,4),(6,5),(6,6),(6,7),(6,8),(6,10),
(8,1),(8,2),(8,3),(8,4),(8,9),(8,10),(8,11);

-- ============================================================
-- VIEWS
-- ============================================================
CREATE OR REPLACE VIEW v_college_summary AS
SELECT
    c.college_id,
    c.college_name,
    c.short_name,
    c.college_type,
    c.affiliation,
    d.district_name,
    p.province_name,
    c.phone,
    c.email,
    c.website,
    c.is_active,
    COUNT(DISTINCT pr.program_id) AS total_programs,
    MIN(pr.annual_fee)            AS min_fee,
    MAX(pr.annual_fee)            AS max_fee
FROM colleges c
LEFT JOIN districts d  ON c.district_id = d.district_id
LEFT JOIN provinces p  ON d.province_id = p.province_id
LEFT JOIN programs  pr ON c.college_id  = pr.college_id AND pr.is_active = 1
WHERE c.is_active = 1
GROUP BY c.college_id, c.college_name, c.short_name, c.college_type,
         c.affiliation, d.district_name, p.province_name, c.phone, c.email, c.website, c.is_active;

CREATE OR REPLACE VIEW v_application_details AS
SELECT
    a.application_id,
    a.user_id,
    u.username,
    u.email,
    sp.full_name,
    c.college_name,
    pr.program_name,
    pr.degree_level,
    f.faculty_name,
    a.status,
    a.applied_date,
    a.remarks,
    a.admin_notes
FROM applications a
JOIN users           u  ON a.user_id    = u.user_id
JOIN student_profiles sp ON u.user_id   = sp.user_id
JOIN programs        pr ON a.program_id = pr.program_id
JOIN colleges        c  ON pr.college_id= c.college_id
JOIN faculties       f  ON pr.faculty_id= f.faculty_id;

-- ============================================================
-- STORED PROCEDURE: Match colleges by eligibility
-- ============================================================
DELIMITER //
CREATE PROCEDURE sp_match_colleges(
    IN p_user_id    INT,
    IN p_faculty_id INT,
    IN p_province   VARCHAR(100)
)
BEGIN
    SELECT DISTINCT
        c.college_id,
        c.college_name,
        c.college_type,
        d.district_name,
        pv.province_name,
        pr.program_id,
        pr.program_name,
        pr.degree_level,
        pr.annual_fee,
        pr.min_percentage,
        pr.entrance_required,
        f.faculty_name,
        CASE
            WHEN ar.percentage >= pr.min_percentage THEN 'Eligible'
            ELSE 'Not Eligible'
        END AS eligibility_status
    FROM colleges c
    JOIN districts  d  ON c.district_id  = d.district_id
    JOIN provinces  pv ON d.province_id  = pv.province_id
    JOIN programs   pr ON c.college_id   = pr.college_id AND pr.is_active = 1
    JOIN faculties  f  ON pr.faculty_id  = f.faculty_id
    LEFT JOIN academic_records ar ON ar.user_id = p_user_id AND ar.level = '+2'
    WHERE c.is_active = 1
      AND (p_faculty_id IS NULL OR pr.faculty_id = p_faculty_id)
      AND (p_province   IS NULL OR pv.province_name = p_province)
    ORDER BY eligibility_status ASC, pr.annual_fee ASC;
END //
DELIMITER ;
