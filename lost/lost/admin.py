from django.contrib import admin

# Register your models here.
from .models import *
class CategoryOption (admin.ModelAdmin):
    list_display = ['id','name','slug']
    prepopulated_fields = {'slug':('name',)}

admin.site.register(Category,CategoryOption)

class ProductOption(admin.ModelAdmin):
    list_display = ['id', 'title', 'slug', 'owner', 'type', 'created', 'updated', 'active']
    prepopulated_fields = {'slug':('item',)}

admin.site.register(Product,ProductOption)
admin.site.register(Comment)