#### MySQL-dockerized

A teacher working on a new question has to provide a standard question description, an example answer for validation and test cases. The basic setup of a test case requires code in the **Extra template data** section which uses Python functions provided by the template. Verification of a test case is done by textual output comparison. When a database engine reports an error it is displayed to the student.

The following subsections briefly describe how a test case is prepared depending on the question type. This question template starts a fresh isolated Docker container for each test case evaluation and stops it at the end. The container grants full administrative access to the database engine, enabling practice with DCL commands such as `GRANT` and `REVOKE` that are not feasible in a shared-server environment. These general guidelines use Python code and can be customized by the teacher accordingly to the course requirements.

#### Python Functions

Two Python functions are available for executing SQL in a test case:

- **`invoke_commandline_sql(db_code, database='test_case', timeout=6, command_line_tool=COMMAND_LINE_TOOL, ignore_warnings=False)`** - executes SQL by spawning the `mysql` command-line tool as a subprocess. The `command_line_tool` parameter can be set to a different binary or argument list when needed. Output is strictly textual. Errors and timeouts terminate the entire script.

- **`invoke_cursor_sql(db_code, database='test_case', ignore_warnings=False, sort_result=False)`** - executes SQL through a database cursor and formats the result as a pandas DataFrame string. Suitable when structured tabular output is needed.

Both functions accept a `database=` parameter - when set to a database name it prepends `USE <name>;` to the SQL; `None` or `False` runs at the server default level.

#### DQL Question Type

This type of question uses the `SELECT` command to extract data from a database. In **Extra template data** section of a test case, firstly, a database is filled with tables, data, etc.; secondly, a student's answer is invoked with output printed on the standard output. Since validation is done in a textual way, the teacher should either a) explicitly put in the question description what columns should the student use to sort results by `ORDER BY` clause; or b) configure the script to sort rows in a pre-processing step before printing to the standard output. See sample code below:

```python
__sql_prepare__ = r'''
-- database init commands e.g. CREATE DATABASE, CREATE TABLE, INSERT etc.
-- ...
'''

invoke_commandline_sql(__sql_prepare__, database=None)
print(invoke_commandline_sql(__student_answer__, database=None))
```

#### DDL/DML Question Type

This type of question checks a student's ability to modify a database, e.g. with `CREATE`, `INSERT` etc. commands. In **Extra template data** section of a test case, firstly, a database is prepared using the `mysql` command-line tool (which handles multi-statement initialization including `CREATE DATABASE`); secondly, a student's answer is invoked in the target database; thirdly, a verification `SELECT` query is invoked with output printed on standard output. See sample code below:

```python
__sql_prepare__ = r'''
-- server-level init e.g. CREATE DATABASE mydb, USE mydb, CREATE TABLE etc.
-- ...
'''

__sql_verify__ = r'''
-- statement checking database structure e.g. SELECT data about
-- columns in a table using INFORMATION_SCHEMA view; test code can be
-- provided here or in 'Test code X' section of a test case
-- ...
'''

invoke_commandline_sql(__sql_prepare__, database=None)
invoke_commandline_sql(__student_answer__, database=None)
print(invoke_commandline_sql(__sql_verify__, database=None))
```

#### DCL Question Type

This type of question checks a student's ability to manage access control, e.g. with `GRANT`, `REVOKE` etc. commands. In **Extra template data** section of a test case, firstly, the necessary users, databases and objects are created; secondly, a student's answer is invoked; thirdly, a verification query inspects the privilege state and prints it on standard output. See sample code below:

```python
__sql_prepare__ = r'''
-- init commands e.g. CREATE DATABASE mydb, CREATE USER 'myuser'@'%',
-- USE mydb, CREATE TABLE etc.
-- ...
'''

__sql_verify__ = r'''
-- statement checking privilege state e.g. SHOW GRANTS FOR 'myuser'@'%'
-- or SELECT from information_schema.USER_PRIVILEGES etc.
-- ...
'''

invoke_commandline_sql(__sql_prepare__, database=None)
invoke_commandline_sql(__student_answer__, database=None)
print(invoke_commandline_sql(__sql_verify__, database=None))
```

#### Other types of assignments

Above we described DQL, DML, DDL and DCL queries but our solution is able to cover problems where a student has to write e.g. SQL script, stored procedures, functions, backup and restore operations etc., as long as created objects persist within the duration of the Docker container for that test case. In the above examples we used `invoke_commandline_sql(...)` which uses by default the `mysql` command-line tool and produces strictly textual output. For questions where programmatic investigation of structured tabular output is needed, `invoke_cursor_sql(...)` can be used instead as it processes data through a database cursor.
