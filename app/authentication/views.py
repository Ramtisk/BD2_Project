from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages


def logout_view(request):
    logout(request)
    response = redirect('login')
    print(f"Antes de deletar: {request.COOKIES}")
    response.delete_cookie('sessionid', domain=None, path='/')
    print(f"Depois de deletar: {response.cookies}")
    return response

def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            login(request, user)
            
            # Determinar o grupo do utilizador
            if user.is_superuser:
                request.session['user_group'] = 'admin'
            elif user.groups.filter(name='cliente').exists():
                request.session['user_group'] = 'cliente'
            elif user.groups.filter(name='fornecedor').exists():
                request.session['user_group'] = 'fornecedor'
            else:
                request.session['user_group'] = 'unknown'

            # Redirecionar com base no grupo do utilizador
            if request.session['user_group'] == 'admin':
                return redirect('adminHome')  # Página do admin
            elif request.session['user_group'] == 'cliente':
                return redirect('clientHome')  # Página do cliente
            elif request.session['user_group'] == 'fornecedor':
                return redirect('fornecedor_home')  # Página do fornecedor
            else:
                messages.error(request, "Sem permissões específicas configuradas.")
                logout(request)
                return redirect('login')
        else:
            messages.error(request, "Credenciais inválidas. Tente novamente.")
            return redirect('login')
    
    return render(request, 'login.html')
