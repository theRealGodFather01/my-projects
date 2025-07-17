from django import forms
from comment.models import Comment

class commentForm(forms.ModelForm):
    text = forms.CharField(widget=forms.Textarea(attrs={'class': 'input is-medium'}), required=True)

    class Meta:
        model = Comment
        fields = ('text',)