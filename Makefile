.PHONY: help setup db-start db-setup run test docs clean all

ifneq (,$(wildcard .env))
  include .env
  export
endif

help:
	@echo "Comandos disponíveis:"
	@echo "  make setup      - Instala dependências e configura credenciais"
	@echo "  make db-start   - Inicia o PostgreSQL"
	@echo "  make db-setup   - Cria as tabelas raw no banco"
	@echo "  make run        - Roda todos os modelos dbt"
	@echo "  make test       - Roda os testes dbt"
	@echo "  make docs       - Gera e abre a documentação"
	@echo "  make clean      - Remove arquivos gerados"
	@echo "  make all        - Roda tudo do zero"

.env:
	@echo "⚠️  Arquivo .env não encontrado!"
	@cp .env.example .env
	@echo "✓ Arquivo .env criado a partir do .env.example"
	@echo ""
	@echo "👉 Abra o arquivo .env e preencha suas credenciais:"
	@echo ""
	@echo "💡 Dica: em DBT_PASSWORD coloque qualquer senha de sua escolha."
	@echo "   O Makefile vai configurar o PostgreSQL com essa mesma senha"
	@echo "   automaticamente — você não precisa fazer nada além disso."
	@echo ""
	@echo "Depois rode make all novamente."
	@exit 1

setup: .env
	pip install dbt-postgres
	@if [ "$(shell uname)" = "Darwin" ]; then \
		which brew > /dev/null 2>&1 || { echo "❌ Homebrew não encontrado. Instale em https://brew.sh"; exit 1; }; \
		echo "export PATH=$$HOME/.local/bin:$$PATH" >> ~/.zshrc; \
	else \
		echo "export PATH=$$HOME/.local/bin:$$PATH" >> ~/.bashrc; \
	fi
	@mkdir -p ~/.dbt
	@echo "marketing_case:" > ~/.dbt/profiles.yml
	@echo "  target: dev" >> ~/.dbt/profiles.yml
	@echo "  outputs:" >> ~/.dbt/profiles.yml
	@echo "    dev:" >> ~/.dbt/profiles.yml
	@echo "      type: postgres" >> ~/.dbt/profiles.yml
	@echo "      host: $(DBT_HOST)" >> ~/.dbt/profiles.yml
	@echo "      port: $(DBT_PORT)" >> ~/.dbt/profiles.yml
	@echo "      user: $(DBT_USER)" >> ~/.dbt/profiles.yml
	@echo "      password: $(DBT_PASSWORD)" >> ~/.dbt/profiles.yml
	@echo "      dbname: $(DBT_DATABASE)" >> ~/.dbt/profiles.yml
	@echo "      schema: $(DBT_SCHEMA)" >> ~/.dbt/profiles.yml
	@echo "      threads: 1" >> ~/.dbt/profiles.yml
	@echo "✓ dbt instalado e profiles.yml configurado"

db-start: .env
	@if [ "$(shell uname)" = "Darwin" ]; then \
		brew services start postgresql@15 || brew services start postgresql; \
	else \
		sudo service postgresql start; \
	fi
	@echo "✓ PostgreSQL iniciado"

db-setup: .env
	sudo -u postgres psql -d postgres -c "ALTER USER postgres PASSWORD '$(DBT_PASSWORD)';"
	sudo -u postgres psql -d postgres -f scripts/create_raw_tables.sql
	@echo "✓ Tabelas raw criadas"

run: .env
	cd marketing_case && dbt run

test: .env
	cd marketing_case && dbt test

docs: .env
	cd marketing_case && dbt docs generate && dbt docs serve

clean:
	cd marketing_case && rm -rf target/ logs/

all: .env db-start db-setup run test
	@echo "✓ Projeto completo!"