        ; 🐟 для Океана-240
        ; Для загрузки в монитор через директиву L
        ; Автор: Тимур Ташпулатов, C.-Петербург 2018
	.download hex
	.org 8000h

BANKING	equ	0c1h		; регистр управления банками ОЗУ и ПЗУ
VIDEO	equ	0e1h		; регистр управления цветом и режимами видео

	mvi	a, 01
	out	BANKING		; включить отображение старших 32К на младшие

	xra	a		; очистить аккумулятор
	lxi	h, 4000h	; поместить в HL адрес начала экранной области
	mvi	d, 0		; очистить регистр D можно было бы на один байт короче

	lxi	b, 256*32	; экран в "Океане" состоит из вертикальных столбиков по 256 байт в каждом
Loop:	mov	m, d		; заполняем экран трухой
	inr	d		; примерно на треть
	inx 	h		; двигаться дальше

	dcx 	b		; внимательно следим за длиной столбика
	mov	a, b		; если столбик 
	ora	c		; не дорисован
	jnz	Loop		; продолжаем писать в экран труху

	lxi	h, 4100h	; цвет каждой точки определяется битами соседних через 100h байт
	mvi	a, 00h		; первый столбик
	call	Strip		; окрашиваем нулём

	lxi	h, 4300h	; второй столбик
	mvi	a, 0fh		; окрашиваем в две полосы
	call	Strip		; для красоты

	lxi	h, 4500h	; третье окно
	mvi	a, 33h		; выходит
	call	Strip		; к океану

	lxi	h, 4700h	; ровным ветром
	mvi	a, 55h		; дышит
	call	Strip		; океан

	lxi	h, 4900h	; а за ним
	mvi	a,0ffh		; диковинные
	call	Strip		; страны

				; и никто
				; не видел
				; этих стран

	xra	a		; экран размалеван
	out	BANKING		; возвращаем его на место

Key:	inr	a		; не пропадать же аккумулятору
	ani	3fh		; возьмем из него три младших бита переднего плана
	ori	40h		; и три старших бита фона
	out	VIDEO		; и намажем на кадр

	call	0e009h		; подождем ввода символа с клавиатуры
	cpi	1bh		; если это не Esc,
	jnz	Key		; продолжим интерактивную раскраску

	jmp	0e003h		; теплый старт "Монитора"

Strip:	mov	m, a		; это подпрограмма
	inx	h		; небыстрого, но верного
	dcr	d		; рисования столбика
	jnz	Strip		; с заданною длиною

	ret			; К О Н Е Ц
