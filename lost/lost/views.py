from django.shortcuts import render

# Create your views here.
from .models import *
from .serializers import *
from rest_framework import filters
from rest_framework import generics
from rest_framework.renderers import JSONRenderer
class ProductLView(generics.ListAPIView):
    renderer_classes = [JSONRenderer]
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    filter_backends = (filters.SearchFilter,)
    search_fields = ('=category__id',)


from django.utils.text import slugify
class ProductCView(generics.CreateAPIView):
    renderer_classes = [JSONRenderer]
    queryset = Product.objects.all()
    serializer_class = ProductCreateSerializer

    def create(self, request, *args, **kwargs):

        request.data._mutable = True
        request.data["owner"] = request.user.id
        request.data["slug"] = slugify(request.data['title'], allow_unicode=True)
        request.data._mutable = False
        return super(ProductCView,self).create(request, *args, **kwargs)


class CommentListView(generics.ListAPIView):
    renderer_classes = {JSONRenderer}
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer
    filter_backends = (filters.SearchFilter,)
    search_fields = ('=post__id',)


class ProductDetialView(generics.RetrieveAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

class CommentCView(generics.CreateAPIView):
    renderer_classes = [JSONRenderer]
    queryset = Comment.objects.all()
    serializer_class = CommentCreateSerializer

    def create(self, request, *args, **kwargs):
        print(request.data)
        try:
            request.data._mutable = True
        except:
            pass
        request.data["writer"] = request.user.id
        try:
            request.data._mutable = False
        except:
            pass
        return super(CommentCView,self).create(request, *args, **kwargs)