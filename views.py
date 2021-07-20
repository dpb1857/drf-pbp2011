from django.shortcuts import render
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import viewsets, pagination, filters

from pbp2011.models import BikeType, Control, Rider
from pbp2011.serializers import BikeTypeSerializer, ControlSerializer, RiderSerializer

# Create your views here.

class BikeTypeViewSet(viewsets.ModelViewSet):
    queryset = BikeType.objects.all()
    serializer_class = BikeTypeSerializer

class ControlViewSet(viewsets.ModelViewSet):
    queryset = Control.objects.all()
    serializer_class = ControlSerializer

class RiderPagination(pagination.LimitOffsetPagination):
    default_limit = 100
    max_limit = 1000

class RiderViewSet(viewsets.ModelViewSet):
    queryset = Rider.objects.all()
    serializer_class = RiderSerializer
    pagination_class = RiderPagination
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['first_name', 'last_name']
    ordering_fields = ['first_name', 'last_name', 'country']
