### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ ec82ce6c-c836-11eb-06d8-59fb3d424e3c
begin
	using Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Compose",version="0.9"),
			Pkg.PackageSpec(name="Colors",version="0.12"),
			Pkg.PackageSpec(name="PlutoUI",version="0.7"),
			])

	using Colors
	using PlutoUI
	using Compose
	using LinearAlgebra
	function Quote(text::AbstractString)
		text |> Markdown.Paragraph |> Markdown.BlockQuote |> Markdown.MD
	end
end

# ╔═╡ c5c569b8-28b6-4679-9474-8bdc527a4f0a
function splitwords(text)
	# clean up whitespace
	cleantext = replace(text, r"\s+" => " ")
	
	# split on whitespace or other word boundaries
	tokens = split(cleantext, r"(\s)")
end

# ╔═╡ 9027d19d-a545-4691-ac6a-d9cb26390e01
poema="""Todos lo son. Salvarse del recuento que en última virtud hase encontrado. De cercana intención no hacer se vuelca, en cada vez con vez pasada. De cada realidad representada. Estarse como sin ver, ya no lamenta. Alivio que hubo de entregar en mi toda voluntad ya impuesta. Clamor que en glosa puesta no ha de tener rito en que se envuelva. Completa locación define entonces, sin otro espacio suyo, que ha de prolongarlo en mí, de cara vuelta nuevamente; sin punto ni diatriba, todo ya hecho. Sobrecoja en cada parte. Que yo también te entrego. No ya en el principio ni la imagen ni ya la voluntad en cada intención que levantada fuera y que ha de esperarse en resultado y consecuencia, yo separado de la forma, solo preservo presentado, búsqueda de cada parte intenta, vuelva a consumirse de entre tiempos, siempre que termina en cada vuelta, siempre entonces hecha. Lamento de esperar no ya presenta, la simple conclusión que no se entrega entonces, cada parte intenta, ya no sin ver, cada vez parte ya hecha. Vuélvase horrorísona mi entrega, simple que heredad ya concebida júzgase derecho, prima idea, toda sostenida. Rápido aliento. Ya todo sobrealzado; misma voluntad en todas partes. Ritmo de concebirse en rito impuesto; no por poner, no ser ya bueno. La entrega a sacar, ahora en consecuencia, ni tanto de alcanzar. Salido esfuerzo. Entonces presenta abierta. De conclusión, vista dorada. Salirse por voluntad, intención más que ya rápida en la espera. La cadencia que distiéndese suave ante el cerco, ya ajeno entre tantos, ya por tantos impuestos. Como no comprende faltada la intención. Sigue de entre tantos, tu presencia, reforma esperanza en todo, centro mío dispuesto en todo, la nueva consecuencia artesonada. Baste en cada intención tuya toda descubierta, para el mismo rito que ahora empieza. Toda mi condición en ti; los nuevos y muchos altares. Incorporándose ya entonces. Misma realidad retrotraída que hubo de tener en todos lo que aparecen de repente. Sin ver el levante. Primera como única evocación que tan sombrosa aparéceles; de tener consecución, prístina realidad que representa recibir de cada parte que ya reposa en voluntad y silencio. De cada toque aún separa. Antes de descubrirlo. Que varía. Como si se extendiera; todo a confluir desde el centro. La misma amplísima apertura, sobre toda culminación ya entonces hecha, ya toda creada. Mirar con voluntad. De cada confluencia entonces. Volver al levante.
No poder verlo entonces dentro. Siempre contenido en donde pasa: no es asumido todavía. Como su fin. Sin par alguno, sin otro movimiento. Su condición oculta. Distendía en tanto. Cerrado con cada condición cumplida: como finitud más y completa. Esa figura, por mí tan cara, y que a ti tanto desde mí reflejo he conformado, te ha entregado: sin tomarte acaso. También en cada acierto confrontado, en ti, donde es nueva voz, que tú ha poco has rechazado ya en violencia, tan tuyo y tan representado: informe desde ti como esta vez mío consuelo. Que me alerta en cada vez ya parecida que en todos tanto dispone. En tan diversa condición: postura otra vez citada; no la solución: no a ti llegada. Esta será tu voluntad: palabra tuya. El mismo ritmo sincopado en la desidia; que otra vez no aborda. Este ya, ahora tan tardo presentado, al descubierto. Acaso puedo yo llamarte nuevamente;  vínculo sin nexo y sin otro referente, acaso. Donde estés: aparecer en este continuo y manifiesto, tal vez por tradición, ya desagrado. Acaso lo posible de no llevar contigo en duro, horrorísono fardo en paso presuroso, esbozo que siempre converge a separados, siempre la elección como tu paso, acaso. Solo un vínculo, así en mi absoluto mío deseo: el vínculo posible, entonces de todo lo dispuesto, en todo lugar que contribuya, en todo este dolor que ahora, en tal momento irreducible, aun nos ata, asiendo la espera de ambos parecidos, de llamarte, acaso. Fuera otro vínculo posible, que esta tradición, toda tan tuya, en mí ya ajena, hase de pensar en casto símbolo: llamarte en lo posible, cual este movimiento al casi logrado desenfado que es por otra palabra ya cambiado, solo similar en el origen. Llamarte por estar, en otro tiempo, en otro espacio, ambos sentados en la vera, ajenos al nuestro incorporar reconcentrado de estos, los más variados, todos ya por ti también por contemplados. Principio sacramento de este nuestro centro desplazado, por un único motivo: nunca encontrado. Si de la luz hemos sido ahora privados, permíteme entonces ya posible poder a voluntad todo llamarte, acaso. Tú: precoz, todo tan tuyo, todo tan rápido. Aventajadnos. No es posible ya quedarse. Que te he entregado: a mí, ahora recuerda. 
Do ut des.
"""

# ╔═╡ ed9b61ec-3146-4b7b-8774-56226aef0dfc
poemaPartido=splitwords(poema)

# ╔═╡ eae92f6a-e30c-415e-8163-17aae06a561d
function ngrams(words, n)
	starting_positions = 1:length(words)-n+1
	
	map(starting_positions) do i
		words[i:i+n-1]
	end
end

# ╔═╡ 22354562-7a63-44c7-89e5-8d6044406066
function completion_cache(grams)
	cache = Dict()
	
	for gram in grams
		if haskey(cache, gram[1:end-1])
			push!(cache[gram[1:end-1]],gram[end])
		else
			cache[gram[1:end-1]]=[gram[end]]
		end
	end
	
	return cache
end

# ╔═╡ e9d47967-0935-4b6d-94a6-3dc500296a84
poemaNGrams=ngrams(poemaPartido,5)

# ╔═╡ 604f2b79-6303-41ac-a633-ce8ca0ce6ba1
poemaCompletion=completion_cache(poemaNGrams)

# ╔═╡ 7c1581ac-d1ee-4862-878a-4aad5d1cf0d9
"""
	generate_from_ngrams(grams, num_words)

Given an array of ngrams (i.e. an array of arrays of words), generate a sequence of `num_words` words by sampling random ngrams.
"""
function generate_from_ngrams(grams, num_words)
	n = length(first(grams))
	cache = completion_cache(grams)
	
	# we need to start the sequence with at least n-1 words.
	# a simple way to do so is to pick a random ngram!
	sequence = [rand(grams)...]
	
	# we iteratively add one more word at a time
	for i ∈ n+1:num_words
		# the previous n-1 words
		tail = sequence[end-(n-2):end]
		
		# possible next words
		completions = cache[tail]
		
		choice = rand(completions)
		push!(sequence, choice)
	end
	sequence
end

# ╔═╡ 2f943db9-73e0-4c35-b059-0fec842276ca
"Compute the ngrams of an array of words, but add the first n-1 at the end, to ensure that every ngram ends in the the beginning of another ngram."
function ngrams_circular(words, n)
	ngrams([words..., words[1:n-1]...], n)
end

# ╔═╡ 0b630b76-502a-4598-85ae-c3a8b70b813a
"""
	generate(source_text::AbstractString, num_token; n=3, use_words=true)

Given a source text, generate a `String` that "looks like" the original text by satisfying the same ngram frequency distribution as the original.
"""
function generate(source_text::AbstractString, s; n=3, use_words=true)
	preprocess = if use_words
		splitwords
	else
		collect
	end
	
	words = preprocess(source_text)
	if length(words) < n
		""
	else
		grams = ngrams_circular(words, n)
		result = generate_from_ngrams(grams, s)
		if use_words
			join(result, " ")
		else
			String(result)
		end
	end
end

# ╔═╡ f9e11c93-a73b-4905-9612-25abfa8b3b0e
md"""Using $(@bind generate_sample_n_words NumberField(1:5))grams for words"""

# ╔═╡ c1ba9b00-8382-49db-aee7-07a54d43a856
generate(
	poema, 110; 
	n=generate_sample_n_words, 
	use_words=true
) |> Quote

# ╔═╡ Cell order:
# ╠═ec82ce6c-c836-11eb-06d8-59fb3d424e3c
# ╠═c5c569b8-28b6-4679-9474-8bdc527a4f0a
# ╠═9027d19d-a545-4691-ac6a-d9cb26390e01
# ╠═ed9b61ec-3146-4b7b-8774-56226aef0dfc
# ╠═eae92f6a-e30c-415e-8163-17aae06a561d
# ╠═22354562-7a63-44c7-89e5-8d6044406066
# ╠═e9d47967-0935-4b6d-94a6-3dc500296a84
# ╠═604f2b79-6303-41ac-a633-ce8ca0ce6ba1
# ╠═7c1581ac-d1ee-4862-878a-4aad5d1cf0d9
# ╠═2f943db9-73e0-4c35-b059-0fec842276ca
# ╠═0b630b76-502a-4598-85ae-c3a8b70b813a
# ╟─f9e11c93-a73b-4905-9612-25abfa8b3b0e
# ╠═c1ba9b00-8382-49db-aee7-07a54d43a856
