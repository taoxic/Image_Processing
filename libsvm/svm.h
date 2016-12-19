#ifndef _LIBSVM_H
#define _LIBSVM_H

#define LIBSVM_VERSION 321

//如果宏定义了__cplusplus则执行。
#ifdef __cplusplus

//extern可以置于变量或者函数前，以标示变量或者函数的定义在别的文件中，
//提示编译器遇到此变量和函数时在其他模块中寻找其定义。此外extern也可用来进行链接指定。

//1.当extern与"C"一起连用时，如: extern "C" void fun(int a, int b);则告诉编译器在编译fun这个函数名时按着C的规则去翻译相应的函数名而不是C++的
extern "C" {
#endif

//2.extern的作用就是声明函数或全局变量的作用范围的关键字，其声明的函数和变量可以在本模块活其他模块中使用，记住它是一个声明不是定义
extern int libsvm_version;


//用来存储单一向量中的单个特征
struct svm_node
{
	int index;
	double value;
};

//存储本次参加运算的所有样本（数据集） ，及其所属类别。在某些数据挖掘实现中，常用DataSet来实现。
struct svm_problem
{
	//记录样本总数
	int l;
	//指向样本所属类别的数组
	double *y;
	//指向一个存储内容为指针的数组
	struct svm_node **x;
};

enum { C_SVC, NU_SVC, ONE_CLASS, EPSILON_SVR, NU_SVR };	/* svm_type */
enum { LINEAR, POLY, RBF, SIGMOID, PRECOMPUTED }; /* kernel_type */


//svm参数
struct svm_parameter
{
	int svm_type;
	int kernel_type;
	int degree;	/* for poly */
	double gamma;	/* for poly/rbf/sigmoid */
	double coef0;	/* for poly/sigmoid */

	/* these are for training only */
	double cache_size; /* in MB 制定训练所需要的内存*/
	double eps;	/* stopping criteria 停止条件*/
	double C;	/* for C_SVC, EPSILON_SVR and NU_SVR 惩罚因子，越大训练的模型越那个…,当然耗的时间越多*/
	int nr_weight;		/* for C_SVC 权重的数目*/
	int *weight_label;	/* for C_SVC 权重，元素个数由nr_weight决定*/
	double* weight;		/* for C_SVC */
	
	
	double nu;	/* for NU_SVC, ONE_CLASS, and NU_SVR */
	double p;	/* for EPSILON_SVR */
	int shrinking;	/* use the shrinking heuristics 指明训练过程是否使用压缩*/
	int probability; /* do probability estimates 指明是否要做概率估计*/
};

//
// svm_model
// 用于保存训练后的训练模型，当然原来的训练参数也必须保留
struct svm_model
{
	struct svm_parameter param;	/* parameter 训练参数*/
	int nr_class;		/* number of classes, = 2 in regression/one class svm 类别数*/
	int l;			/* total #SV 支持向量数*/
	struct svm_node **SV;		/* SVs (SV[l]) 保存支持向量的指针*/
	double **sv_coef;	/* coefficients for SVs in decision functions (sv_coef[k-1][l]) 相当于判别函数中的alpha*/
	double *rho;		/* constants in decision functions (rho[k*(k-1)/2]) */
	double *probA;		/* pariwise probability information */
	double *probB;
	int *sv_indices;        /* sv_indices[0,...,nSV-1] are values in [1,...,num_traning_data] to indicate SVs in the training set */

	/* for classification only */

	int *label;		/* label of each class (label[k]) */
	int *nSV;		/* number of SVs for each class (nSV[k]) */
				/* nSV[0] + nSV[1] + ... + nSV[k-1] = l */
	/* XXX */
	int free_sv;		/* 1 if svm_model is created by svm_load_model*/
				/* 0 if svm_model is created by svm_train */
};
// 最主要的驱动函数，训练数据
struct svm_model *svm_train(const struct svm_problem *prob, const struct svm_parameter *param);

//用SVM做交叉验证
void svm_cross_validation(const struct svm_problem *prob, const struct svm_parameter *param, int nr_fold, double *target);

//保存训练好的模型到文件
int svm_save_model(const char *model_file_name, const struct svm_model *model);

//从文件中把训练好的模型读到内存中
struct svm_model *svm_load_model(const char *model_file_name);


int svm_get_svm_type(const struct svm_model *model);

//得到数据集的类别数（必须经过训练得到模型后才可以用）
int svm_get_nr_class(const struct svm_model *model);
//得到数据集的类别标号（必须经过训练得到模型后才可以用）
void svm_get_labels(const struct svm_model *model, int *label);
void svm_get_sv_indices(const struct svm_model *model, int *sv_indices);
int svm_get_nr_sv(const struct svm_model *model);
double svm_get_svr_probability(const struct svm_model *model);


//用训练好的模型预报样本的值，输出结果保留到数组中。（并非接口函数）
double svm_predict_values(const struct svm_model *model, const struct svm_node *x, double* dec_values);

//预报某一样本的值
double svm_predict(const struct svm_model *model, const struct svm_node *x);
double svm_predict_probability(const struct svm_model *model, const struct svm_node *x, double* prob_estimates);

void svm_free_model_content(struct svm_model *model_ptr);
void svm_free_and_destroy_model(struct svm_model **model_ptr_ptr);

//消除训练的模型，释放资源
void svm_destroy_param(struct svm_parameter *param);

//检查输入的参数，保证后面的训练能正常进行。
const char *svm_check_parameter(const struct svm_problem *prob, const struct svm_parameter *param);
int svm_check_probability_model(const struct svm_model *model);

void svm_set_print_string_function(void (*print_func)(const char *));

#ifdef __cplusplus
}
#endif

#endif /* _LIBSVM_H */

/*→统计类别总数,同时记录类别的标号，统计每个类的样本数目
→将属于相同类的样本分组，连续存放
→计算权重C

→训练n(n-1)/2个模型

→初始化nozero数组，便于统计SV
→//初始化概率数组
→训练过程中，需要重建子数据集，样本的特征不变，但样本的类别要改为+1/-1
→//如果有必要，先调用svm_binary_svc_probability
→训练子数据集svm_train_one
→统计一下nozero,如果nozero已经是真，就不变，如果为假，则改为真
→输出模型
→主要是填充svm_model,
→清除内存*/
