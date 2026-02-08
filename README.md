# GRANT Privileges, REVOKE Risk: Safe and Scalable Teaching of Database Administration with Isolated Containers

[![Workshop Badge](https://img.shields.io/badge/workshop-DataEd_2026-blue.svg)](https://dataedinitiative.github.io/DataEd26/index.html) [![Conference Badge](https://img.shields.io/badge/conference-EDBT/ICDT_2026-orange.svg)](https://edbticdt2026.github.io/) [![URL](https://img.shields.io/badge/URL-CEUR--WS-ff69b4.svg)](https://ceur-ws.org/Vol-4192/DataEd-paper1.pdf)

**Authors:** [Andrzej Wójtowicz](https://awojt.pl), Maciej Prill

```
@inproceedings{wojtowicz2026grant,
    author = {Wójtowicz, Andrzej and Prill, Maciej},
    title = {GRANT Privileges, REVOKE Risk: Safe and Scalable Teaching of Database Administration with Isolated Containers},
    year = {2026},
    booktitle = {Proceedings of the Workshops of the EDBT/ICDT 2026 Joint Conference},
    issn = {1613-0073},
    series = {CEUR Workshop Proceedings},
    volume = {4192},
    url = {https://ceur-ws.org/Vol-4192/DataEd-paper1.pdf},
    numpages = {11},
    pages = {1-11},
    abstract = {Database administration is an essential but often underrepresented area in academic curricula due to the complexity and infrastructural demands of teaching elevated-privilege operations. Existing LMS-based autograders support only restricted SQL practice and cannot accommodate administrative tasks such as user management, backups, or performance tuning. To address these limitations, we developed an extension to CodeRunner in Moodle that enables full administrative interaction with Microsoft SQL Server, MySQL, and PostgreSQL using temporary, isolated Docker containers. This architecture provides each student with a safe, fully privileged environment for engaging in realistic, hands-on work. We deployed this solution in a new Database Administration course and evaluated it through surveys, task completion data, and performance tests. Students reported high satisfaction with the system’s usability and realism, confirming the feasibility and effectiveness of the proposed approach, while also indicating areas for future refinement.}
}
```

## Description

This repository contains the code accompanying the research paper presented at the [DataEd](https://dataedinitiative.github.io/DataEd26/index.html) workshop of the [EDBT/ICDT](https://edbticdt2026.github.io/) joint conference in 2026. The paper is available in the [CEUR Workshop Proceedings](https://ceur-ws.org/Vol-4192/DataEd-paper1.pdf).

This repository focuses on testing tasks related to database administration activities, particularly DCL, and its architecture is based on dynamically created Docker containers. If you're only interested in testing DQL, DDL, and DML queries, e.g., on a pre-built database, take a look at the solution available in repository from [SIGCSE 2025](https://github.com/andre-wojtowicz/coderunner-sql-sigcse2025), which offers a simpler and much faster approach using shared containers.

## Servers config

LMS server:

* [Ubuntu Server](https://ubuntu.com) 24.04
* [Moodle](https://moodle.org/) 5.1.3
* [CodeRunner](https://coderunner.org.nz/) plugins:
  * [qbehaviour_adaptive_adapted_for_coderunner](https://moodle.org/plugins/qbehaviour_adaptive_adapted_for_coderunner) 1.4.4
  * [qtype_coderunner](https://moodle.org/plugins/qtype_coderunner) 5.8.0

Grading server:

* [Debian](https://www.debian.org) 12.13
* [Jobe](https://github.com/trampgeek/jobe) 2.2.1

## Repository

The repository is organized as follows:

- `mssql-dockerized/` - files and instructions for Microsoft SQL Server,
- `mysql-dockerized/` - files and instructions for MySQL,
- `postgresql-dockerized/` - files and instructions for PostgreSQL.

In each directory, there are the following files:

* `INSTALL.md` with instructions to run on the grading server,
* `requirements.txt` with Python pip modules,
* `*.xml` with question prototype and sample questions to import in Moodle course (it is best to familiarize yourself with sample questions by adding them directly to the quiz later),
* `README.md` with a description of the prototype (it is also available in Moodle question editor in the "Question type details" section).
