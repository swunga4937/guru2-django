from django.shortcuts import render

# Create your views here.
from .serializers import *
from django.contrib.auth import get_user_model
from rest_framework import generics
from rest_framework.response import Response
from rest_framework.renderers import  JSONRenderer

class UserListView(generics.ListAPIView):
    queryset = get_user_model().objects.all()
    serializer_class = UserListSerializer

class MyInfoView(generics.ListAPIView):
    queryset = get_user_model().objects.all()
    serializer_class = UserListSerializer

    def get_queryset(self):
        queryset = super().get_queryset()
        queryset = queryset.filter(pk=self.request.user.id)
        return queryset

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset().first()
        serializers = self.get_serializer(queryset)
        return Response(serializers.data)

from rest_framework.permissions import AllowAny

class UserCreateView(generics.CreateAPIView):
    serializer_class = UserCreateSerializer
    permission_classes = [AllowAny]


