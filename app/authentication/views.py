import os
import psycopg2
from django.shortcuts import render, redirect
from django.contrib import messages

# Função auxiliar para autenticar o utilizador e verificar o grupo no PostgreSQL
def authenticate_postgres_user(username, password):
    try:
        conn = psycopg2.connect(
            dbname=str(os.getenv('POSTGRES_DB')),
            user=username,
            password=password,
            host="postgres",
            port="5432"
        )
        cursor = conn.cursor()
        cursor.execute("SELECT tipo FROM tipos WHERE username = %s", (username,))
        user_type = cursor.fetchone()
        conn.close()

        if user_type:
            return user_type[0]  # Retorna o grupo (tipo) do utilizador
        else:
            return None
    except psycopg2.OperationalError as e:
        print(f"Erro de autenticação: {e}")
        return None
    except Exception as e:
        print(f"Erro inesperado: {e}")
        return None

# View para login
def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        if not username or not password:
            messages.error(request, "Todos os campos são obrigatórios.")
            return redirect('login')

        user_group = authenticate_postgres_user(username, password)
        if user_group:
            request.session['username'] = username
            request.session['user_group'] = user_group  # Armazena o grupo na sessão

            if user_group == 'admin':
                return redirect('admin_homepage')
            elif user_group == 'forn':
                return redirect('fornecedor_homepage')
            elif user_group == 'client':
                return redirect('client_homepage')
            else:
                messages.warning(request, "Sem permissões definidas.")
                return redirect('login')
        else:
            messages.error(request, "Credenciais inválidas.")
            return redirect('login')
    return render(request, 'login.html')

# View para logout
def logout_view(request):
    request.session.flush()
    messages.success(request, "Sessão terminada com sucesso.")
    return redirect('login')

# View para a página inicial do admin
def admin_homepage(request):
    if 'username' not in request.session or request.session.get('user_group') != 'admin':
        messages.error(request, "Acesso negado. Por favor, faça login.")
        return redirect('login')
    return render(request, 'admin_homepage.html', {'username': request.session.get('username')})

# View para a página inicial do fornecedor
def fornecedor_homepage(request):
    if 'username' not in request.session or request.session.get('user_group') != 'forn':
        messages.error(request, "Acesso negado. Por favor, faça login.")
        return redirect('login')
    return render(request, 'fornecedor_homepage.html', {'username': request.session.get('username')})

# View para a página inicial do cliente
def client_homepage(request):
    if 'username' not in request.session or request.session.get('user_group') != 'client':
        messages.error(request, "Acesso negado. Por favor, faça login.")
        return redirect('login')
    return render(request, 'client_homepage.html', {'username': request.session.get('username')})
