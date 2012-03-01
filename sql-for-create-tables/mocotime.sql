DROP TABLE IF EXISTS tab_mocotime_wanttodo;
CREATE TABLE tab_mocotime_wanttodo (
  _id INTEGER PRIMARY KEY AUTOINCREMENT,
  col_title VARCHAR(255) NOT NULL,
  col_image_path VARCHAR(255) NOT NULL,
  col_required_time INTEGER NOT NULL
);
