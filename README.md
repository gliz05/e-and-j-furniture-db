# E and J Furniture Database

MySQL/MariaDB schema for the E and J Furniture order, inventory, pricing, and administration system. The schema follows the supplied corrected ERD and data dictionary.

## Contents

- `sql/schema.sql` — creates the `ej_furniture` database and its tables, keys, referential actions, and checks.

## Requirements

- MySQL 8.0+ or a compatible MariaDB release with InnoDB and `CHECK` constraint support.
- XAMPP users can run this through phpMyAdmin or the MySQL command-line client.

## Setup

> The script creates a new database named `ej_furniture`. It does not drop or modify another database. If a database with that name already exists, `CREATE DATABASE` will return an error; back up any data and handle that case deliberately rather than adding destructive statements blindly.

### phpMyAdmin / XAMPP

1. Start MySQL in the XAMPP Control Panel.
2. Open phpMyAdmin and select the **Import** tab.
3. Choose `sql/schema.sql` and run the import.
4. Confirm that the `ej_furniture` database and its tables appear in the sidebar.

### MySQL command line

```sh
mysql -u root -p < sql/schema.sql
```

Omit `-p` if the local MySQL account has no password. Use the credentials configured for your own installation.

## Schema coverage

The schema includes customer and address records; staff and roles; furniture catalog and material requirements; materials, units, inventory, and inventory transactions; customer orders, items, deliveries, status history, adjustments, notes, and reservations; price rules and estimates; payments; notifications; logs; and backup records.

Foreign keys use `ON UPDATE CASCADE`, with delete behavior chosen per relationship (`CASCADE`, `SET NULL`, or `RESTRICT`). Check constraints enforce basic nonnegative/positive values and valid date relationships. MySQL versions older than 8.0.16 may parse but not enforce `CHECK` constraints; validate your server version before relying on them.

## Important notes

- The schema intentionally contains no sample records. Insert lookup/reference records (such as roles, units, categories, transaction types, delivery types, and statuses) before creating records that reference them.
- Store only securely generated password hashes in `STAFF.password_hash`; never store plaintext passwords.
- Test schema changes and application behavior against a disposable development database before using production data.
