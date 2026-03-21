.PHONY: help setup db-start db-setup run test docs clean all

help:
	@echo "Comandos disponíveis:"
	@echo "  make setup      - Instala dependências"
	@echo "  make db-start   - Inicia o PostgreSQL"
	@echo "  make db-setup   - Cria as tabelas raw no banco"
	@echo "  make run        - Roda todos os modelos dbt"
	@echo "  make test       - Roda os testes dbt"
	@echo "  make docs       - Gera e abre a documentação"
	@echo "  make clean      - Remove arquivos gerados"
	@echo "  make all        - Roda tudo do zero"

setup:
	pip install dbt-postgres
	@echo "export PATH=$$HOME/.local/bin:$$PATH" >> ~/.bashrc
	@echo "✓ dbt instalado"

db-start:
	sudo service postgresql start
	@echo "✓ PostgreSQL iniciado"

db-setup:
	sudo -u postgres psql -d postgres -c "ALTER USER postgres PASSWORD 'postgres123';"
	sudo -u postgres psql -d postgres -f scripts/create_raw_tables.sql
	@echo "✓ Tabelas raw criadas"

run:
	cd marketing_case && dbt run

test:
	cd marketing_case && dbt test

docs:
	cd marketing_case && dbt docs generate && dbt docs serve

clean:
	cd marketing_case && rm -rf target/ logs/

all: db-start db-setup run test
	@echo "✓ Projeto completo!"
