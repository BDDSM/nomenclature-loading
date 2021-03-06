﻿Перем мМетаНоменклатура;
Перем мБазоваяЕдиницаИзмерения;
Перем глТекущийПользователь;
Перем мТекущаяОбласть;

//======================================================================================================================
// Обработчики формы

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	//{[+](фрагмент ДОБАВЛЕН), Волокитин Александр Сергеевич 02.12.2019 14:47:33
	// не забыть убрать комментарий.
	//Отказ = НЕ КонтрольПрав.ПравоДоступа_Просмотр(ЭтотОбъект);
КонецПроцедуры

Процедура ПриОткрытии()
	Инициализировать();	
КонецПроцедуры

Процедура Инициализировать()
	//{[+](фрагмент ДОБАВЛЕН), Волокитин Александр Сергеевич 02.12.2019 14:47:33
	// не забыть убрать.
	ПерваяСтрока = 2;
	ПутьКФайлу   = "C:\Users\vas\Desktop\Загрузка номенклатуры.xls";
	
	гСохраненнаяНастройка = "Основная";
	мМетаНоменклатура = Метаданные.Справочники.Номенклатура;
	КонтрагентСнхронизации = "";
	ПровайдерЗагрузки =  "1C";	
	//ПервичнаяНастройка();
	ВостановитьНастройку(гСохраненнаяНастройка);
	
	
	ОтборЗагрузка = ЭлементыФормы.СоответствиеКолонок.ОтборСтрок.Загружать;
	ОтборЗагрузка.ВидСравнения = ВидСравнения.Равно;
	ОтборЗагрузка.Значение		= Истина;
	ОтборЗагрузка.Использование= Истина;
	
	// тест
	ОсновныеДействияФормыПрофильПросмотр(Неопределено);	
	ЗагрузитьДанныеДляОбработки();
	
КонецПроцедуры	


//======================================================================================================================
// Обработчики кнопок на странице Профиль

Процедура ПутьКФайлуНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ДиалогОткрытияФайла=Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	//ДиалогОткрытияФайла.ПолноеИмяФайла= "";	
	ДиалогОткрытияФайла.Фильтр="Excel(*.xl*)|*.xl*";
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";
	Если ДиалогОткрытияФайла.Выбрать() тогда
		ПутьКФайлу=ДиалогОткрытияФайла.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыПрофильПросмотр(Кнопка)
	
	ТабДокумент = ЗагрузкаДанныхИзФайла(ПутьКФайлу, ПровайдерЗагрузки);
	Если ТабДокумент <> Неопределено Тогда
		
		ЭлементыФормы.ПредварительныйПросмотр.Очистить();
		
		ЭлементыФормы.ПредварительныйПросмотр.Вывести(ТабДокумент);
		//Костыль Ошибка отображение у платформы 1С:Предприятие 8.3 (8.3.12.1790)
		ЭлементыФормы.ПредварительныйПросмотр.Области[0].Шрифт = Новый Шрифт("Arial", 10);
	КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаСвязатьНажатие(Элемент)
	ТекущийНомерКолонки = ЭлементыФормы.ПредварительныйПросмотр.ТекущаяОбласть.Лево;
	СвязатьРазвязатьКолонки(ТекущийНомерКолонки, Истина);
	
	ВыделитьОбластьДокумента(ТекущийНомерКолонки);
	
КонецПроцедуры

Процедура КнопкаОтвязатьНажатие(Элемент)
	ТекущийНомерКолонки = ЭлементыФормы.ПредварительныйПросмотр.ТекущаяОбласть.Лево;
	СвязатьРазвязатьКолонки(ТекущийНомерКолонки, Ложь);
	
	Если мТекущаяОбласть <> Неопределено Тогда
		мТекущаяОбласть.ЦветФона = WebЦвета.Белый;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредварительныйПросмотрВыбор(Элемент, Область, СтандартнаяОбработка)
	ТекущийНомерКолонки = ЭлементыФормы.ПредварительныйПросмотр.ТекущаяОбласть.Лево;
	СвязатьРазвязатьКолонки(ТекущийНомерКолонки, Истина);
КонецПроцедуры

Процедура ОсновныеДействияФормыПрофильДалее(Кнопка)
	ЭтаФорма.Панель.ТекущаяСтраница = ЭтаФорма.Панель.Страницы.ДопНастройки; 
КонецПроцедуры

Процедура ВостановитьНастройкиНажатие(Элемент)
	
	ВостановитьНастройку(Неопределено);

КонецПроцедуры

Процедура ВостановитьНастройку(НаименованиеНастройки)
	
    СтруктураНастройки = Новый Структура;
	СтруктураНастройки.Вставить("Пользователь", МТИ.ПолучитьЗначениеКонстанты("ПользовательЭлектронныйЗаказчик"));
	СтруктураНастройки.Вставить("ИмяОбъекта", Строка(ЭтотОбъект));
	СтруктураНастройки.Вставить("НаименованиеНастройки", НаименованиеНастройки);
	
	Результат = УниверсальныеМеханизмы.ВосстановлениеНастроек(СтруктураНастройки);
	Если Результат <> Неопределено Тогда
		
		ПрописатьСтруктуруНастроек(Результат.СохраненнаяНастройка);
		
	КонецЕсли;

КонецПроцедуры //ВостановитьНастройку

Процедура СохранитьНастройкиНажатие(Элемент)
	
	СохраненнаяНастройка = ПолучитьСтруктуруНастроек();
	
	СтруктураНастройки = Новый Структура;
	СтруктураНастройки.Вставить("Пользователь", МТИ.ПолучитьЗначениеКонстанты("ПользовательЭлектронныйЗаказчик"));
	СтруктураНастройки.Вставить("ИмяОбъекта", Строка(ЭтотОбъект));
	СтруктураНастройки.Вставить("НаименованиеНастройки", Неопределено);
	СтруктураНастройки.Вставить("СохраненнаяНастройка", СохраненнаяНастройка);
	СтруктураНастройки.Вставить("ИспользоватьПриОткрытии", Ложь);
	СтруктураНастройки.Вставить("СохранятьАвтоматически", Ложь);
	
	Результат = УниверсальныеМеханизмы.СохранениеНастроек(СтруктураНастройки);

КонецПроцедуры

Функция ПолучитьСтруктуруНастроек()
	
	ИменаИсключения =  Новый Соответствие();
	ИменаИсключения.Вставить("НаименованиеНастройки");
	
	СтруктураСохранения = Новый Структура;
	
	КолРеквизитов  = ЭтотОбъект.Метаданные().Реквизиты;
	Для каждого ЭлРеквизит Из КолРеквизитов Цикл
		
		Если ИменаИсключения.Получить(ЭлРеквизит.Имя) = Неопределено Тогда
			СтруктураСохранения.Вставить(ЭлРеквизит.Имя, ЭтотОбъект[ЭлРеквизит.Имя]);
		КонецЕсли;
		
	КонецЦикла;
	
	СтруктураСохранения.Вставить("НастройкиПоиска", ЗначениеВСтрокуВнутр(НастройкиПоиска.Выгрузить() ) );	
	
	Возврат СтруктураСохранения;
	
КонецФункции

Процедура ПрописатьСтруктуруНастроек(СохраненнаяНастройка)
	
	КолРеквизитов  = ЭтотОбъект.Метаданные().Реквизиты;
	
	Для каждого ЭлРеквизит Из КолРеквизитов  Цикл
		
		СохраненнаяНастройка.Свойство(ЭлРеквизит.Имя, ЭтотОбъект[ЭлРеквизит.Имя]);
		
	КонецЦикла;		

	СтрНастройкиПоиска = "";
	Если СохраненнаяНастройка.Свойство("НастройкиПоиска", СтрНастройкиПоиска) Тогда
		
		мТаблица = ЗначениеИзСтрокиВнутр(СтрНастройкиПоиска);
		Если ТипЗнч(мТаблица) = Тип("ТаблицаЗначений") Тогда
			НастройкиПоиска.Загрузить(мТаблица);
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СвязатьРазвязатьКолонки(ТекущийНомерКолонки, ДействиеСвязать)
	
	мТекСтрокаКолонки = ЭлементыФормы.СоответствиеКолонок.ТекущаяСтрока;
	Если мТекСтрокаКолонки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДействиеСвязать Тогда
		// нужно проверить а не связанно ли в других колонках текущая.
		мТекСтрокаКолонки.НомерКолонки = ТекущийНомерКолонки;
	Иначе 
		мТекСтрокаКолонки.НомерКолонки = 0;
	КонецЕсли;
	
КонецПроцедуры

Процедура СоответствиеКолонокПриАктивизацииСтроки(Элемент)
	
	ВыделитьОбластьДокумента(Элемент.ТекущаяСтрока.НомерКолонки);
	
КонецПроцедуры

Процедура ВыделитьОбластьДокумента(НомерКолонки)
	
	Если мТекущаяОбласть <> Неопределено Тогда
		мТекущаяОбласть.ЦветФона = WebЦвета.Белый;
	КонецЕсли;	
	
	Если НомерКолонки > 0  Тогда
		мТекущаяОбласть = ЭлементыФормы.ПредварительныйПросмотр.Область(1, НомерКолонки, ЭлементыФормы.ПредварительныйПросмотр.ВысотаТаблицы, НомерКолонки);
		
		мТекущаяОбласть.ЦветФона = WebЦвета.ЖелтоЗеленый;		
	КонецЕсли;

КонецПроцедуры



//======================================================================================================================
// Обработчики кнопок на странице Доп Настройки


Процедура КоманднаяПанель2ЗаполнитьОсновныеРеквизиты(Кнопка)
	
	ПервичнаяНастройка();	
	
КонецПроцедуры

Процедура НастройкиПоискаПриИзмененииФлажка(Элемент, Колонка)
	// глюк при смене страниц, оставется в таблице пустая стройка.
	ЭлементыФормы.СоответствиеКолонок.ОбновитьСтроки();
	
	
	Если Колонка.ДанныеФлажка = "ИспользоватьРеадактирование" 
		И Элемент.ТекущаяСтрока.Загружать 
		И НЕ Элемент.ТекущаяСтрока.ИспользоватьРеадактирование Тогда
		
		Элемент.ТекущаяСтрока.Загружать = Ложь;
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОсновныеДействияФормы1ОсновныеДействияФормыВыполнить(Кнопка)
	ЭтаФорма.Панель.ТекущаяСтраница = ЭтаФорма.Панель.Страницы.Обработка; 
	ЗагрузитьДанныеДляОбработки();
КонецПроцедуры






Процедура ПервичнаяНастройка(ПолныйСостав = Ложь)
		
	НастройкиПоиска.Очистить();
	
	РекНоменклатура = мМетаНоменклатура.Реквизиты;
	
	СписокРеквизитИспользования = ПолучитьЗаготовкиНастроек(ПолныйСостав);
	
	Для каждого Реквизит Из РекНоменклатура Цикл
		
		ТекНастройка = СписокРеквизитИспользования.Найти(Реквизит.Имя, "ИмяРеквизита");
		
		Если ТекНастройка <> Неопределено Тогда
			
			СтрокаНастройкиПоиска = НастройкиПоиска.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНастройкиПоиска,	ТекНастройка);
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

Функция ПолучитьЗаготовкиНастроек(ПолныйСостав)
	// СоздадимТаблицуНастроек для хранения начальных данных.
	// для редактирования данных в любых ситуациях
	
	ТаблицаНачальныхДанных = НастройкиПоиска.Выгрузить(); 	
	ТаблицаНачальныхДанных.Очистить();		 
	
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"Артикул",						"Справочники.Номенклатура.НайтиПоРеквизиту(""Артикул"", ДанныеЯчейки)", Ложь, Ложь);
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"НаименованиеПолное",			"", Истина, Истина);
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"НоменклатурнаяГруппа",		"", Истина, , Справочники.НоменклатурныеГруппы.ПустаяСсылка());
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"НомерГТД",					"", Ложь,   , Справочники.НомераГТД.ПустаяСсылка());
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ОсновнойПоставщик",			"", Ложь,   , Справочники.Контрагенты.ПустаяСсылка());
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ОтветственныйМенеджерЗаПокупки","",Ложь,  , Справочники.Пользователи.ПустаяСсылка());
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"СтавкаНДС",					"", Истина, , Перечисления.СтавкиНДС.НДС20);
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"СтранаПроисхождения",			"", Ложь, Ложь,Справочники.КлассификаторСтранМира.Россия);
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ЦеноваяГруппа",				"", Истина, , Справочники.ЦеновыеГруппы.ПустаяСсылка());
	
	//ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ДополнительноеОписаниеНоменклатуры","", Истина);
	
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"БазоваяЕдиницаИзмерения",		"", Истина, , Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду(""));
	
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"АртикулПроизводителя",		"", Истина);
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"Дубликат",					"", Истина, Истина);
	
	//ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"КатегорияПродаж","", Ложь);
	
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"НомерПоКаталогу",				"", Истина, Истина);
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"КоличествоВУпаковке",			"", Ложь,  , 1);
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"Сертификат",					"", Ложь,  ,Справочники.Сертификаты.ПустаяСсылка() );
	//ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"АльтернативнаяГруппа","", Истина);
	//ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ПоисковыеТеги","", Истина);
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"КратностьОтгрузки",			"", Ложь,  , 1);
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ПроизводительПоКаталогу",		"Результат = Справочники.Производители.НайтиПоНаименованию(ДанныеЯчейки)", Истина);
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"Бренд",						"Результат = Справочники.Бренды.НайтиПоНаименованию(ДанныеЯчейки)", Истина, Истина); 
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"АртикулБренда",				"", Истина, Истина);
	
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"Производитель",				"Результат = Справочники.Производители.НайтиПоНаименованию(ДанныеЯчейки)", Истина);
	//ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"КодТНВЭД","", Истина);
	
	// подумать как к
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"Код",							"ТекущиеДанные.Ссылка = Справочники.Номенклатура.НайтиПоКоду(ДанныеЯчейки)", Ложь);
	ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"Наименование",				"", Ложь);
	
	
	
	Если ПолныйСостав Тогда
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"СтатьяЗатрат",					"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"Весовой", 						"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ВестиПартионныйУчетПоСериям", 	"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ВестиУчетПоСериям", 				"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ВестиУчетПоХарактеристикам", 		"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ЕдиницаДляОтчетов", 				"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ЕдиницаХраненияОстатков", 		"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"Комментарий", 					"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"Набор", 							"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ОсновноеИзображение", 			"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"Услуга",							"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"НоменклатурнаяГруппаЗатрат",		"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ВестиСерийныеНомера", 			"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"Комплект", 						"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ЕдиницаИзмеренияМест", 			"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"АлкогольнаяПродукция", 			"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ОбъемДАЛ", 						"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"АртикулДляПодбора", 				"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"КодИ", 							"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"КодЭЗ", 							"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ОсновнойШтрихКод", 				"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ПозицияДляГруппировки", 			"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"КатегорияНоменклатуры", 			"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ВесовойКоэффициентВхождения", 	"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ВидАлкогольнойПродукцииЕГАИС", 	"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"Крепость", 						"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ИмпортнаяАлкогольнаяПродукция", 	"", Ложь);
		ДобавитьСтрокуНачальныеДанные(ТаблицаНачальныхДанных,"ПроизводительИмпортерАлкогольнойПродукции", "", Ложь);
	КонецЕсли;	
	
	Возврат ТаблицаНачальныхДанных;
	
КонецФункции

Процедура ДобавитьСтрокуНачальныеДанные(мТаблицаНачальныхДанных, мИмяРеквизита, мНастройкиПоиска = "", мИспользоватьРеадактирование = Ложь, мЗагружать = Ложь, мЗначениеПоУмолчанию = Неопределено)
	
	НоваяСтрока =  мТаблицаНачальныхДанных.Добавить();
	
	НоваяСтрока.ИмяРеквизита    			= мИмяРеквизита;
	НоваяСтрока.НастройкиПоиска 			= мНастройкиПоиска;
	НоваяСтрока.ИспользоватьРеадактирование = мИспользоватьРеадактирование;	
	НоваяСтрока.Загружать 					= мЗагружать;
	Если ЗначениеЗаполнено(мЗначениеПоУмолчанию) Тогда
		НоваяСтрока.ЗначениеПоУмолчанию 		= мЗначениеПоУмолчанию;
	Иначе 
		// установить тип данных для значения... в элементеФормы.
		//ТипДанныхКолонки = ПолучитьТипРеквизита(мИмяРеквизита);
		//НоваяСтрока.ЗначениеПоУмолчанию = ТипДанныхКолонки; 
		
	КонецЕсли;
	
	
КонецПроцедуры	




//======================================================================================================================
// Обработчики кнопок на странице Обработка

Процедура ЗагрузитьДанныеДляОбработки()
	
	
	СоздатьКолонкиВТЧДанные();
	
	ТабличныйДокумент = ЭлементыФормы.ПредварительныйПросмотр;
	
	Если НастройкиПоиска.НайтиСтроки(Новый Структура("Загружать", Истина)).Количество() = 0 Тогда
		Предупреждение("Не отмечено колонок для загрузки!");
		Возврат;
	КонецЕсли;
	
	КоличествоЭлементов = ТабличныйДокумент.ВысотаТаблицы - ПерваяСтрока + 1;
	Если КоличествоЭлементов <= 0 Тогда
		Предупреждение("Нет данных для конвертации.");
		Возврат;
	КонецЕсли;
		
		
	Данные.Очистить();
	
	Для К = ПерваяСтрока По ТабличныйДокумент.ВысотаТаблицы Цикл	
		
		ДобавитьИЗаполненияСтрокуДанных(ТабличныйДокумент, К);
		
	КонецЦикла;	
	
КонецПроцедуры 

//======================================================================================================================
// ТабличныйДокумент - документ откуда будут подгружатся данные 
// НомерСтроки - номер стоки ТабличныйДокумента которая будет анализироваться
// СтрокаДанных - стока таблицы Данные куда будут заносится значение ил Табличного документа
//
Процедура ДобавитьИЗаполненияСтрокуДанных(ТабличныйДокумент, НомерСтроки)
	
	// Все данные по стороке
	ТекстыЯчеек = Новый Массив;
	ТекстыЯчеек.Добавить(Неопределено);
	Для СчетчикЯчейки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
		ТекстыЯчеек.Добавить(СокрЛП(ТабличныйДокумент.Область(НомерСтроки, СчетчикЯчейки).Текст));
	КонецЦикла;
	
	
	Результат 	 = "";
	ДанныеЯчейки = "";
	Запрос = Новый Запрос();
		
	
	// странно но добавляем строку в ТЧ Данные.
	СтрокаДанных = Данные.Добавить();

		
	Для каждого СтрокаСопоставления Из НастройкиПоиска Цикл
		
		
		Если СтрокаСопоставления.Загружать
			И СтрокаСопоставления.НомерКолонки > 0 Тогда
			
						
			Результат 	 = ТекстыЯчеек[СтрокаСопоставления.НомерКолонки];
			ТекстЯчейки = Результат;
			
			Запрос.УстановитьПараметр("ДанныеЯчейки", ТекстЯчейки);
			
			Если СокрЛП(СтрокаСопоставления.НастройкиПоиска) = "" Тогда
				
				Если ЗначениеЗаполнено(СтрокаСопоставления.ЗначениеПоУмолчанию)  Тогда
					СтрокаДанных[СтрокаСопоставления.ИмяРеквизита] = СтрокаСопоставления.ЗначениеПоУмолчанию;
				Иначе
					СтрокаДанных[СтрокаСопоставления.ИмяРеквизита] = Результат;
				КонецЕсли;
				
			Иначе				
				                                   //Знач Выражение, ТекущиеДанные, Знач ТекстЯчейки,  Знач Запрос, Знач ТекстыЯчеек, Знач Результат)
				Вычисление  = ВычислитьЗначениеЯчейки(СтрокаСопоставления.НастройкиПоиска, СтрокаДанных, ТекстЯчейки, Запрос, ТекстыЯчеек, Результат);
				
				Результат   = Вычисление.Результат;				
				
				Если НЕ ЗначениеЗаполнено(Результат) Тогда
					Результат = СтрокаСопоставления.ЗначениеПоУмолчанию;
				КонецЕсли;
	
				СтрокаДанных[СтрокаСопоставления.ИмяРеквизита] = Результат;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ВычислитьЗначениеЯчейки(Знач Выражение, ТекущиеДанные, Знач ТекстЯчейки,  Знач Запрос, Знач ТекстыЯчеек, Знач Результат)
		
	Попытка
		Выполнить(Выражение);
	Исключение
		мСообщитьОбОшибке(ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Новый Структура("Результат",Результат);
	
КонецФункции // ВычислитьЗначениеЯчейки(ТекущаяСтрока,Представление)()





Процедура СоздатьКолонкиВТЧДанные()
	
	Данные.Колонки.Очистить();
	
	Данные.Колонки.Добавить("Записать", Новый ОписаниеТипов("Булево"),,5);
	
	Данные.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"),,100);
	
	Для каждого СтрокаНастройки Из НастройкиПоиска Цикл
		Если СтрокаНастройки.ИспользоватьРеадактирование Тогда
			ТипДанныхКолонки = ПолучитьТипРеквизита(СтрокаНастройки.ИмяРеквизита);
			ШиринаКолонки = ПолучитьШиринуКолонки(ТипДанныхКолонки);
			Данные.Колонки.Добавить(СтрокаНастройки.ИмяРеквизита, ТипДанныхКолонки, СтрокаНастройки.ИмяРеквизита, ШиринаКолонки)
		КонецЕсли;	
	КонецЦикла;	
	
	ЭлементыФормы.Данные.СоздатьКолонки();
	
	ЭлементыФормы.Данные.Колонки.Записать.ТолькоПросмотр=Ложь;
    ЭлементыФормы.Данные.Колонки.Записать.ТекстШапки="";
    ЭлементыФормы.Данные.Колонки.Записать.УстановитьЭлементУправления(Тип("Флажок"));
    ЭлементыФормы.Данные.Колонки.Записать.РежимРедактирования=РежимРедактированияКолонки.Непосредственно;
    ЭлементыФормы.Данные.Колонки.Записать.Данные="";
    ЭлементыФормы.Данные.Колонки.Записать.ДанныеФлажка="Записать";
    //ЭлементыФормы.Данные.Колонки.Записать.Ширина=20;
	
	
КонецПроцедуры //СоздатьКолонкиДанные

Функция ПолучитьТипРеквизита(мИмяРеквизита)
	
	Попытка
		Результат = мМетаНоменклатура.Реквизиты.Найти(мИмяРеквизита).Тип;
	Исключение
		Если мИмяРеквизита = "Записать"  Тогда
			Результат = Новый ОписаниеТипов("Булево"); 
		Иначе 	
		    Результат = Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(25)); 
		КонецЕсли;	
	КонецПопытки;	
	
	Возврат Результат;	
КонецФункции

Функция ПолучитьШиринуКолонки(ТипДанныхКолонки)
	
	Если гСохраненнаяНастройка = "" Тогда
		// Без расчета  по максимальной дринны экрана.
		Если ТипДанныхКолонки.СодержитТип(Тип("Строка")) Тогда
			Если ТипДанныхКолонки.КвалификаторыСтроки.Длина = 0 Тогда
				Результат = 100;
			Иначе 	
				Результат = Мин(ТипДанныхКолонки.КвалификаторыСтроки.Длина, 80);
			КонецЕсли;
		ИначеЕсли ТипДанныхКолонки.СодержитТип(Тип("Число")) Тогда
			Результат = 70;
		Иначе
			Результат = 30;
		КонецЕсли;
	Иначе 
		// попытаемся востановить из сохраненных настроек
		
	КонецЕсли;
	
	
	
	Возврат Результат;
КонецФункции

Процедура НастройкиПоискаНастройкиПоискаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ФормаРедактированияВыражения = ПолучитьФорму("ФормаРедактированияВыражения");
	
	ПолеТекстовогоДокумента = ФормаРедактированияВыражения.ЭлементыФормы.ПолеТекстовогоДокумента;
	ПолеТекстовогоДокумента.УстановитьТекст(Элемент.Значение);
	
	Если ФормаРедактированияВыражения.ОткрытьМодально() = Истина Тогда
		Элемент.Значение = ПолеТекстовогоДокумента.ПолучитьТекст();
	КонецЕсли;

КонецПроцедуры

Процедура КоманднаяПанель1ЗаполнитьВыделенные(Кнопка)
	
	СписокВиделенныхСтрок = ЭлементыФормы.Данные.ВыделенныеСтроки;
	ТекущаяКолонка        = ЭлементыФормы.Данные.ТекущаяКолонка;
	
	Если ТекущаяКолонка <> Неопределено
		И СписокВиделенныхСтрок.Количество() > 0 Тогда
		
		НовоеЗначение = "";
		
		Если ВвестиЗначение(НовоеЗначение, "Новое значение для колонки " + ТекущаяКолонка.Данные, ПолучитьТипРеквизита(ТекущаяКолонка.Данные)) Тогда
			
			Для каждого СтрТовары Из СписокВиделенныхСтрок Цикл
				СтрТовары[ТекущаяКолонка.Данные] = НовоеЗначение;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанель1Установить(Кнопка)
	ПрописатьЗначениеДляКолонок("Записать", Истина);
КонецПроцедуры

Процедура КоманднаяПанель1Снять(Кнопка)
	ПрописатьЗначениеДляКолонок("Записать", Ложь);
КонецПроцедуры


Процедура ПрописатьЗначениеДляКолонок(ИмяКолонки, Значение)
	
	Для каждого СтрТовары Из Данные Цикл
		СтрТовары[ИмяКолонки] = Значение;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОсновныеДействияФормы2ОсновныеДействияФормыВыполнить(Кнопка)
	
	// спросить продолжить ?
	
	Для каждого СтрокаДанных Из Данные Цикл
		Если СтрокаДанных.Записать Тогда
			СтрокаДанных.Ссылка = СоздатьОбновитьНоменклатуру(СтрокаДанных);
		КонецЕсли;	
	КонецЦикла;
	
	
	
КонецПроцедуры

Функция СоздатьОбновитьНоменклатуру(СтрокаДанных)	
	
	ЗаписаЭлемент  = Ложь;		
	СоздатьНовыйЭлемент = Не ЗначениеЗаполнено(СтрокаДанных.Ссылка);
	
	Если СоздатьНовыйЭлемент Тогда
		ОбъектНоменклатура =  Справочники.Номенклатура.СоздатьЭлемент();
	Иначе
		ОбъектНоменклатура =  СтрокаДанных.Ссылка.ПолучитьОбъект();
	КонецЕсли;
	
	РекНоменклатура = мМетаНоменклатура.Реквизиты;
	Для каждого Реквизит Из РекНоменклатура Цикл	
		ЗаполнитьРеквизитСправочника(ОбъектНоменклатура, Реквизит.Имя, СтрокаДанных, СоздатьНовыйЭлемент, ЗаписаЭлемент);
	КонецЦикла;
	// Нету этих реквизитов в Метаданных
	ЗаполнитьРеквизитСправочника(ОбъектНоменклатура, "Наименование", СтрокаДанных, СоздатьНовыйЭлемент, ЗаписаЭлемент);
	ЗаполнитьРеквизитСправочника(ОбъектНоменклатура, "Родитель",     СтрокаДанных, СоздатьНовыйЭлемент, ЗаписаЭлемент);	
	
	Если ЗаписаЭлемент Тогда
		
		НачатьТранзакцию();
		
			Попытка
				ОбъектНоменклатура.Записать();
			Исключение
				ОтменитьТранзакцию();
			    мСообщитьОбОшибке(ОписаниеОшибки());
				Возврат Справочники.Номенклатура.ПустаяСсылка();
			КонецПопытки;
		
			// записать ЕдиницуИзмерения
			Если СоздатьНовыйЭлемент Тогда
				ОбъектЕдиница = Справочники.ЕдиницыИзмерения.СоздатьЭлемент();
			Иначе 
				ОбъектЕдиница = ОбъектНоменклатура.ЕдиницаХраненияОстатков.ПолучитьОбъект();
			КонецЕсли;	
				
			РеквизитыСправочника = Метаданные.Справочники.ЕдиницыИзмерения.Реквизиты;	
			Для каждого Реквизит Из РеквизитыСправочника Цикл
				
				ЗаполнитьРеквизитСправочника(ОбъектЕдиница, Реквизит.Имя, СтрокаДанных, СоздатьНовыйЭлемент, ЗаписаЭлемент);
					
			КонецЦикла;				
			
			Если СоздатьНовыйЭлемент Тогда
				ОбъектЕдиница.Владелец  = ОбъектНоменклатура.Ссылка;
				
				// костыль С наименованием.
				ОбъектЕдиница.Наименование = ОбъектЕдиница.ЕдиницаПоКлассификатору.Наименование;
			КонецЕсли; 
							
			Попытка
				ОбъектЕдиница.Записать();
			Исключение
				ОтменитьТранзакцию();
			    мСообщитьОбОшибке(ОписаниеОшибки());
				Возврат Справочники.Номенклатура.ПустаяСсылка();
			КонецПопытки;
			
			//ОбъектНоменклатура.ЕдиницаИзмеренияМест 	= ОбъектЕдиница.Ссылка;
			ОбъектНоменклатура.ЕдиницаХраненияОстатков  = ОбъектЕдиница.Ссылка;
			ОбъектНоменклатура.ЕдиницаДляОтчетов  		= ОбъектЕдиница.Ссылка;
			
			Попытка
				ОбъектНоменклатура.Записать();
			Исключение
				ОтменитьТранзакцию();
			    мСообщитьОбОшибке(ОписаниеОшибки());
				Возврат Справочники.Номенклатура.ПустаяСсылка();
			КонецПопытки;
			
		ЗафиксироватьТранзакцию();
		
		Возврат ОбъектНоменклатура.Ссылка;
		
	Иначе 
		// куня... какая то.
		Возврат СтрокаДанных.Ссылка;
		
	КонецЕсли;
	
КонецФункции

//======================================================================================================================
// Найдем значение в строке данных
// Проверим что это не новый элемент,
// ОбъектСправочник - справочник Объект
// СтрокаДанных - строка таблице Данные
// ЗаписаЭлемент  - признак необходимости записать объект. выставляется если мы изменили значение объекта
Процедура ЗаполнитьРеквизитСправочника(ОбъектСправочник, ИмяРеквизита, СтрокаДанных, СоздатьЭлемент, ЗаписаЭлемент)
	
	//!!! проверить на список исключений реквизитов запрещенных к редактированию	
	
	Значение = Неопределено;
	НайденнаяКолонка = СтрокаДанных.Владелец().Колонки.Найти(ИмяРеквизита);
	Если НайденнаяКолонка <> Неопределено Тогда	
		Значение = СтрокаДанных[ИмяРеквизита]; 
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Значение) Тогда 
		
		// не хорошо но подбираем значения по умолчанию.
		Если ИмяРеквизита = "Весовой" Тогда	
			Значение = Ложь;
			
		ИначеЕсли ИмяРеквизита = "НаименованиеПолное" Тогда			
			НайденнаяКолонка = СтрокаДанных.Владелец().Колонки.Найти("Наименование");
			Если НайденнаяКолонка <> Неопределено Тогда	
				Значение = СтрокаДанных["Наименование"];
			КонецЕсли;
			
		ИначеЕсли ИмяРеквизита = "Наименование" Тогда			
			НайденнаяКолонка = СтрокаДанных.Владелец().Колонки.Найти("НаименованиеПолное");
			Если НайденнаяКолонка <> Неопределено Тогда	
				Значение = СтрокаДанных["НаименованиеПолное"];
			КонецЕсли;			
			
		ИначеЕсли ИмяРеквизита = "СтавкаНДС" Тогда	
			Значение = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ОсновнаяСтавкаНДС");
			Если Не ЗначениеЗаполнено(Значение) Тогда
				Значение = Перечисления.СтавкиНДС.НДС20;
			КонецЕсли;	
			
		ИначеЕсли ИмяРеквизита = "ОтветственныйМенеджерЗаПокупки" Тогда					
			Значение = ПараметрыСеанса.ТекущийПользователь; // ??
			
		ИначеЕсли ИмяРеквизита = "ВестиПартионныйУчетПоСериям" Тогда
			Значение = Ложь;
			
		ИначеЕсли ИмяРеквизита = "ВестиУчетПоСериям" Тогда
			Значение = Ложь;
			
		ИначеЕсли ИмяРеквизита = "ВестиУчетПоХарактеристикам" Тогда
			Значение = Ложь;
			
		ИначеЕсли ИмяРеквизита = "Набор" Тогда
			Значение = Ложь;
			
		ИначеЕсли ИмяРеквизита = "НоменклатурнаяГруппа" Тогда
			Значение =  УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "НоменклатурнаяГруппа");
			Если НЕ ЗначениеЗаполнено(Значение) Тогда
				Значение = МТИ.ПолучитьЗначениеКонстанты("НоменклатурнаяГруппаВсеПодразделения");
			КонецЕсли;
			
		ИначеЕсли ИмяРеквизита = "Услуга" Тогда
			Значение = Ложь;
			
		ИначеЕсли ИмяРеквизита = "ВидНоменклатуры" Тогда			
			Если ЗначениеЗаполнено(РодительДляНовойНоменклатуры.ВидНоменклатуры) Тогда
				Значение = РодительДляНовойНоменклатуры.ВидНоменклатуры;
			Иначе
				Значение = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ОсновнойВидНоменклатуры");
			КонецЕсли;

			Если НЕ ЗначениеЗаполнено(Значение)  Тогда
				Значение = Справочники.ВидыНоменклатуры.НовыйОптоваяБаза;
			КонецЕсли;				
			
		ИначеЕсли ИмяРеквизита = "ВестиСерийныеНомера" Тогда
			Значение = Ложь;	
			
		ИначеЕсли ИмяРеквизита = "Комплект" Тогда
			Значение = Ложь;	
			
		ИначеЕсли ИмяРеквизита = "АлкогольнаяПродукция" Тогда
			Значение = Ложь;	
			
		ИначеЕсли ИмяРеквизита = "БазоваяЕдиницаИзмерения"
			  ИЛИ ИмяРеквизита = "ЕдиницаПоКлассификатору" Тогда
			  
			Значение = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ОсновнаяЕдиницаПоКлассификатору");  
			Если Не ЗначениеЗаполнено(Значение) Тогда   
				Значение = мБазоваяЕдиницаИзмерения;
			КонецЕсли;	
			
		ИначеЕсли ИмяРеквизита = "Коэффициент"
			  ИЛИ ИмяРеквизита = "Кратность" Тогда
			Значение = 1; //???	
						
		ИначеЕсли ИмяРеквизита = "Родитель" Тогда
			Значение = РодительДляНовойНоменклатуры; //???   			
			
		КонецЕсли;	
		
	КонецЕсли;	
	
	//!!! Проверить на обязательные к заполнению поля
	
	
	Если ЗначениеЗаполнено(Значение) 
		И ОбъектСправочник[ИмяРеквизита] <> Значение Тогда 
		
		ОбъектСправочник[ИмяРеквизита] = Значение;
	  	ЗаписаЭлемент = Истина;
		
	КонецЕсли;	
	
КонецПроцедуры



мБазоваяЕдиницаИзмерения =  Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду("796"); //???
глТекущийПользователь    =  глЗначениеПеременной("глТекущийПользователь");






