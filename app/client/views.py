from datetime import timedelta
from django.contrib import messages
from django.http import JsonResponse, HttpResponseBadRequest
from django.shortcuts import render, redirect,get_object_or_404
from project.models import Plan, Subscription, PlanSubscription
from django.utils.timezone import now
from django.db import connection

def ClientView(request):
    if request.session.get('user_group') not in ['admin', 'client' ]:
        messages.error(request, "Acesso negado.")
        return redirect('login')
    if request.method == 'GET':
        user = request.user.username  # Obtém o username do cliente logado

        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM get_user_planos(%s)", [user])
            subscribed_plans = cursor.fetchall() 
        subscribed_plan_ids = [plan[0] for plan in subscribed_plans]
        plans = Plan.objects.all()
        return render(request, 'client.html', {
            'plans': plans,
            'subscribed_plan_ids': subscribed_plan_ids
        })
    else:
        return HttpResponseBadRequest("Método não permitido.")

def ClientSignView(request, id):
    plan = get_object_or_404(Plan, pk=id)
    user = request.user
    if request.session.get('user_group') not in ['admin', 'client' ]:
        messages.error(request, "Acesso negado.")
        return redirect('login')
    
    if request.method == 'GET':
        return render(request, 'client_sign.html', {'plan': plan})

    elif request.method == 'POST':
        subscription = Subscription.objects.create(
            user=user,
            start_date=now(),
            end_date=now() + timedelta(days=365)
        )
        PlanSubscription.objects.create(
            plan=plan,
            subscription=subscription,
        )
        return redirect('clientHome');

    elif request.method == 'PUT':
        subscription = Subscription.objects.filter(user=user, plansubscription__plan=plan).first()

        if subscription:
            subscription.end_date = now()
            subscription.save()

        return redirect('clientHome')

    return JsonResponse({'error': 'Método não permitido'}, status=405)
