from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login
from django.contrib import messages

def login_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            login(request, user)
            # Redirecionar com base no papel do usuário
            if user.is_superuser:
                return redirect('/backoffice')  # Página do administrador
            elif user.groups.filter(name='cliente').exists():
                return redirect('/client')  # Página do cliente/fornecedor
            else:
                messages.error(request, "Sem permissões específicas configuradas para este usuário.")
                return redirect('login')
        else:
            messages.error(request, "Credenciais inválidas. Tente novamente.")
            return redirect('login')
    
    return render(request, 'login.html')
#
# def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            login(request, user)
            # Persistir dados na sessão
            request.session['username'] = username
            request.session['is_superuser'] = user.is_superuser
            request.session['user_groups'] = list(user.groups.values_list('name', flat=True))
            
            # Redirecionar com base no papel do usuário
            if user.is_superuser:
                return redirect('/backoffice')  # Página do administrador
            elif 'cliente' in request.session['user_groups']:
                return redirect('/client')  # Página do cliente/fornecedor
            else:
                messages.error(request, "Sem permissões específicas configuradas para este usuário.")
                return redirect('login')
        else:
            messages.error(request, "Credenciais inválidas. Tente novamente.")
            return redirect('login')
    
    return render(request, 'login.html')

def client_home(request):
    if 'username' not in request.session or 'cliente' not in request.session.get('user_groups', []):
        messages.error(request, "Acesso negado. Faça login.")
        return redirect('login')
    
    username = request.session['username']
    return render(request, 'client_home.html', {'username': username})

#