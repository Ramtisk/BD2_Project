from django.http import JsonResponse, HttpResponseBadRequest
from django.shortcuts import render
from project.models import Plan

def ClientView(request):
    if request.method == 'GET':
        plans = Plan.objects.all()
        print(f"Plans encontrados: {plans}")  # Log para verificar se os dados estão sendo carregados
        return render(request, 'client.html', {'plans': plans})
    else:
        return HttpResponseBadRequest("Método não permitido.")
