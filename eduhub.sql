CREATE TABLE members (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE courses (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0)
);

CREATE TABLE registrations (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_id INT NOT NULL REFERENCES members (id),
    course_id INT NOT NULL REFERENCES courses (id),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    registered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (member_id, course_id)
);

CREATE INDEX ix_reg_course ON registrations (course_id);

INSERT INTO members (full_name, email) VALUES
('Nguyễn An', 'an@dthu.edu.vn'),
('Trần Bình', 'binh@dthu.edu.vn'),
('Lê Chi', 'chi@dthu.edu.vn');

INSERT INTO courses (title, capacity) VALUES
('Lập trình Web', 2),
('Cơ sở dữ liệu', 40);

INSERT INTO registrations (member_id, course_id) VALUES
(1, 1),
(1, 2),
(2, 1);
---1
SELECT c.title
FROM registrations r
JOIN members m ON m.id = r.member_id
JOIN courses c ON c.id = r.course_id
WHERE m.full_name = 'Nguyễn An';
---2
SELECT c.title, COUNT(r.id) AS so_dang_ky
FROM courses c
LEFT JOIN registrations r ON r.course_id = c.id
GROUP BY c.id, c.title
ORDER BY so_dang_ky DESC;
---3
BEGIN;

DELETE FROM registrations 
WHERE member_id = 3;

INSERT INTO registrations (member_id, course_id)
VALUES (3, 2);

COMMIT;