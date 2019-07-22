from django.db import models
from django.contrib.auth import get_user_model
# Create your models here.

class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)
    slug = models.SlugField(unique=True, allow_unicode=True)

    def __str__(self):
        return self.name

#category.product_set
#category.category_products

GET_TYPE=(
    (1, '---'),
    (2, '분실'),
    (3, '습득')
)

PRODUCT_TYPE=(
    (1, '---'),
    (2, '가방'),
    (3, '전자기기'),
    (4, '지갑'),
    (5, '학용품'),
    (6, '기타')
)

class Product(models.Model):
    category = models.ForeignKey(Category, on_delete=models.PROTECT, related_name='category_products', verbose_name='분실/습득 장소')
    owner = models.ForeignKey(get_user_model(), on_delete=models.PROTECT, related_name='my_products', verbose_name='아이디')
    title = models.CharField(max_length=100, verbose_name='제목', default='')
    item = models.CharField(max_length=100, verbose_name='분실물', default='')
    kind = models.IntegerField(blank=True, choices=PRODUCT_TYPE, verbose_name='종류', default=1)
    whenGet = models.CharField(max_length=100, verbose_name='분실/습득 시간', default='')
    image = models.ImageField(blank=True, upload_to='products/', verbose_name='이미지')
    slug = models.SlugField(unique=True, allow_unicode=True, verbose_name='슬러그')
    type = models.IntegerField(blank=True, choices=GET_TYPE, verbose_name='분실/습득', default=1)
    description = models.TextField(verbose_name='설명')
    active = models.BooleanField(blank=True, default=True, verbose_name='찾음')
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title


class Comment(models.Model):
    post = models.ForeignKey('lost.Product', on_delete=models.PROTECT, related_name='comments')
    writer = models.ForeignKey(get_user_model(), on_delete=models.PROTECT, related_name='my_comments', verbose_name='아이디')
    text = models.TextField()
    created_date = models.DateTimeField(auto_now_add=True)
    approved_comment = models.BooleanField(default=False)

    def approve(self):
        self.approved_comment = True
        self.save()

    def __str__(self):
        return self.text


# c00835413ca0f93ad8be48b2d67ab3a54709a9db