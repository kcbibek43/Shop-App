import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';
class EditProductScreen extends StatefulWidget {

  static const routeName = '/edit-product';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}


class _EditProductScreenState extends State<EditProductScreen> {
   final _priceFocusNode = FocusNode();
    final _descriptionFocusNode = FocusNode();
    final _imageURLController = TextEditingController();
    final _imageUrlFocusNode = FocusNode();
    final _form = GlobalKey<FormState>();
    
    var _editedProduct = Product(
      id:  '',
      title: '',
      price: 0,
      description: '',
      imageUrl:  '',
      isFavroite: false,
    );

    var _initValue = {
      'title': '',
      'description': '',
      'price': '',
      'imageUrl': '',
       };
    var _isInit = true;
    var _isLoading = false;

    @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(_isInit){
        final productId = ModalRoute.of(context)?.settings.arguments as String?;
        if(productId != null){
      _editedProduct =  Provider.of<Products>(context,listen: false).findById(productId);
       _initValue = {
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'price': _editedProduct.price.toString(),
        'imageUrl': '',
       };
       _imageURLController.text = _editedProduct.imageUrl;
       }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl(){
     if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageURLController.text.startsWith('http') &&
              !_imageURLController.text.startsWith('https')) ||
          (!_imageURLController.text.endsWith('.png') &&
              !_imageURLController.text.endsWith('.jpg') &&
              !_imageURLController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
     }
  }
  Future<void> _saveForm() async{
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
  _form.currentState!.save();
  setState(() {
    _isLoading = true;
  });
if (_editedProduct.id != '') {
await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);  
    } else {
      try{
   await Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
      }catch(error){
         await showDialog(context: context, builder: (ctx) => AlertDialog(title: const Text('An error occured!'), content: const Text('SomeThing went wrong!'),
         actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: const Text('Okay'),)
         ],
         )
         );
      }
    }
     setState(() {
            _isLoading = false;
          });     
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm
          , icon: 
          const Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading ? 
      const Center(
        child: CircularProgressIndicator(),
      ) :
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
        children: [
          TextFormField(
            initialValue: _initValue['title'],
            decoration: const InputDecoration(
            labelText: 'Title',
          ),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_){
          FocusScope.of(context).requestFocus(_priceFocusNode);
        },
        validator: (value){
          if((value as String).isEmpty){
            return 'Please provide a value';
          }
          return null;
        },
        onSaved: (val){
          _editedProduct = Product( title: val as String, id: _editedProduct.id,description: _editedProduct.description, imageUrl: _editedProduct.imageUrl, price: _editedProduct.price, isFavroite: _editedProduct.isFavroite);
        },
        ),
        TextFormField(
           initialValue: _initValue['price'],
          decoration: const InputDecoration(
            labelText: 'Price',
          ),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        focusNode: _priceFocusNode,
         onFieldSubmitted: (_){
          FocusScope.of(context).requestFocus(_descriptionFocusNode);
        },
        validator: (value){
          if((value as String).isEmpty){
            return 'Please fill the required field';
          }
          if(double.tryParse(value) == null){
              return 'Please Enter a valid number .';
          }
          if(double.parse(value)<=0){
            return 'Please return valid number';
          }
          return null;
        },
         onSaved: (val){
          _editedProduct = Product( title: _editedProduct.title, id: _editedProduct.id,price: double.parse(val as String) ,imageUrl: _editedProduct.imageUrl,description: _editedProduct.description , isFavroite: _editedProduct.isFavroite);
        },
        ),
        TextFormField(
          initialValue: _initValue['description'],
          decoration: const InputDecoration(
            labelText: 'Description',
          ),
          maxLines: 3,
        keyboardType: TextInputType.multiline,
         focusNode: _descriptionFocusNode,
          validator: (value){
         if((value as String).isEmpty){
         return 'Please Enter a description';
         }
         if(value.length<10){
          return 'Should be at least 10 character ';
         }
         return null;
        },
        onSaved: (val){
          _editedProduct = Product( title: _editedProduct.title, id: _editedProduct.id,price: _editedProduct.price,imageUrl: _editedProduct.imageUrl,description: val as String , isFavroite: _editedProduct.isFavroite);
        },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(top: 8,right: 10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
            ),
            child: _imageURLController.text.isEmpty ? Text('Enter a URL') : FittedBox(
           child: Image.network(_imageURLController.text,
           fit: BoxFit.cover,),
            ),
          ),
        Expanded(
          child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Image URL',
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
                controller: _imageURLController,
               focusNode: _imageUrlFocusNode,
               validator: (value){
                if((value as String).isEmpty){
                  return 'Please enter an image URL';
                }
                if(!value.startsWith('http') && !value.startsWith('https')){
                  return 'Please enter a Valid URL';
                }
                if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')){
                  return 'Please enter a valid image URL.';
                }
                return null;
               },
            onSaved: (val){
          _editedProduct = Product( title: _editedProduct.title, id: _editedProduct.id,price: _editedProduct.price ,imageUrl: val as String ,description: _editedProduct.description , isFavroite: _editedProduct.isFavroite);
        },
      onFieldSubmitted: (_){
        _saveForm();
        },
            ),
        )
        ],)
        ],
        ),),
      ),
    );
    
  }
    @override
  void dispose() {
  _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageURLController.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }
 
}